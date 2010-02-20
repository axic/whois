#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'iconv'
require 'whois/answer/part'
require 'whois/answer'


module Whois
  class Server
    module Adapters
      
      class Base

        # Default Whois request port.
        DEFAULT_WHOIS_PORT = 43

        attr_reader :type
        attr_reader :allocation
        attr_reader :host
        attr_reader :options
        attr_reader :buffer

        def initialize(type, allocation, host, options = {})
          @type       = type
          @allocation = allocation
          @host       = host
          @options    = options || {}
        end

        # Performs a Whois query for <tt>qstring</tt> 
        # using current server adapter and returns a <tt>Whois::Response</tt>
        # instance with the result of the request.
        #
        # server.query("google.com")
        # # => Whois::Response
        #
        def query(qstring)
          with_buffer do |buffer|
            request(qstring)
            Answer.new(self, buffer)
          end
        end

        def request(qstring)
          raise NotImplementedError
        end


        protected

          def with_buffer(&block)
            @buffer = []
            result = yield(@buffer)
            # @buffer = []
            # result
          end
          
          # Store an answer part in <tt>@buffer</tt>.
          def append_to_buffer(response, host)
            response = Iconv.conv('utf-8', @options[:charset], response) if @options[:charset]
            @buffer << ::Whois::Answer::Part.new(response, host)
          end

          def query_the_socket(qstring, host, port = nil)
            ask_the_socket(qstring, host, port || options[:port] || DEFAULT_WHOIS_PORT)
          end

        private

          def ask_the_socket(qstring, host, port)
            client = TCPSocket.open(host, port)
            client.write("#{qstring}\r\n")  # I could use put(foo) and forget the \n
            client.read                     # but write/read is more symmetric than puts/read
          ensure                            # and I really want to use read instead of gets.
            client.close if client          # If != client something went wrong.
          end
        
      end
      
    end
  end
end