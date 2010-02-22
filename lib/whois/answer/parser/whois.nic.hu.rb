#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Gábor Vészi <veszig@done.hu>, Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.nic.hu parser
      #
      # Parser for the whois.nic.hu server.
      #
      class WhoisNicHu < Base
        include Ast

        # Returns the registry disclaimer that comes with the answer.
        property_supported :disclaimer do
          node('Disclaimer')
        end

        # If available, returns the domain name as stored by the registry.
        property_supported :domain do
          node('Domain')
        end

        # If available, returns the unique domain ID set by the registry.
        property_supported :domain_id do
          node('hun-id')
        end

        # Returns the record status: <tt>:available</tt>, <tt>:in_progress</tt>
        # or <tt>:registered</tt>.
        property_supported :status do
          if node('NotFound')
            :available
          elsif node('InProgress')
            :in_progress
          else
            :registered
          end
        end

        # Returns whether this record is available.
        property_supported :available? do
          @available ||= status == :available
        end

        # Returns whether this record is registered.
        property_supported :registered? do
          @registered ||= status == :registered
        end

        # If available, returns a Time object representing the date
        # the record was created, according to the registry answer.
        property_supported :created_on do
          node('registered') { |raw| Time.parse(raw) }
        end

        # If available, returns a Time object representing the date
        # the record was last updated, according to the registry answer.
        property_supported :updated_on do
          node('changed') { |raw| Time.parse(raw) }
        end

        # If available, returns a <tt>Whois::Answer::Contact</tt> record
        # containing the registrant details extracted from the registry answer.
        property_supported :registrant do
          if registered?
            answer = Answer::Contact.new(
              :name => node('name'),
              :organization => node('org'),
              :phone => node('phone'),
              :fax => node('fax-no'),
              :created_on => created_on,
              :updated_on => updated_on,
              :id => node('hun-id')
            )
            if node('address')
              answer.address = node('address')[0]
              answer.country_code = node('address')[2]
              a1 = node('address')[1].split(/\s/)
              answer.zip = a1.shift
              answer.city = a1.join(' ')
            end
            return answer
          end
        end

        # If available, returns an array of name servers entries for this domain
        # if any name server is available in the registry answer.
        property_supported :nameservers do
          node('nameserver')
        end

        # If available, returns a <tt>Whois::Answer::Contact</tt> record
        # containing the admin contact details extracted from the registry answer.
        property_supported :admin do
          contact('admin-c')
        end

        # If available, returns a <tt>Whois::Answer::Contact</tt> record
        # containing the technical contact details extracted from the registry answer.
        property_supported :technical do
          contact('tech-c')
        end

        # If available, returns a <tt>Whois::Answer::Contact</tt> record
        # containing the zone contact details extracted from the registry answer.
        property_supported :zone_contact do
          contact('zone-c')
        end

        # If available, returns a <tt>Whois::Answer::Contact</tt> record
        # containing the registrar contact details extracted from the registry answer.
        property_supported :registrar_contact do
          contact('registrar')
        end

        property_supported :registrar do
          if rc = registrar_contact
            Answer::Registrar.new(
              :id => rc[:id],
              :name => rc[:name],
              :organization => rc[:organization]
            )
          end
        end

        protected

          def parse
            Scanner.new(content_for_scanner).parse
          end

          def contact(element)
            node(node(element)) do |raw|
              Answer::Contact.new do |c|
                raw.each { |k,v| c[k.to_sym] = v }
              end
            end
          end


        class Scanner

          def initialize(content)
            @input = StringScanner.new(content)
          end

          def parse
            @ast = {}
            while !@input.eos?
              trim_newline  ||
              parse_content
            end
            @ast
          end

          private

            def trim_newline
              @input.scan(/\n/)
            end

            def parse_content
              parse_disclaimer  ||
              parse_domain      ||
              parse_not_found   ||
              parse_in_progress ||
              parse_domain_data ||
              parse_contacts    ||
              trim_newline      ||
              error("Unexpected token")
            end

            def parse_disclaimer
              if @input.match?(/% Whois server .*\n/)
                @input.scan_until(/\n\n/)
                lines = []
                while @input.match?(/\S+/) && @input.scan(/(.*)\n/)
                  lines << @input[1].strip
                end
                @ast['Disclaimer'] = lines.join("\n")
                true
              end
              false
            end

            def parse_domain
              if @input.match?(/\ndomain:\s+\S+\n/) && @input.scan(/\ndomain:\s+(\S+)\n/)
                @ast['Domain'] = @input[1].strip
                true
              end
              false
            end

            # FIXME: Requires UTF-8 Encoding (see #11)
            def parse_not_found
              if @input.match?(/\nNincs (.*?) \/ No match\n/)
                @input.scan(/\nNincs (.*?) \/ No match\n/)
                return @ast['NotFound'] = true
              end
              @ast['NotFound'] = false
            end

            # FIXME: Requires UTF-8 Encoding (see #11)
            def parse_in_progress
              if @input.match?(/(.*?) folyamatban \/ Registration in progress\n/)
                 @input.scan(/(.*?) folyamatban \/ Registration in progress\n/)
                 return @ast['InProgress'] = true
              end
              @ast['InProgress'] = false
            end

            def parse_domain_data
              if @input.match?(/\S+:[ ]+.*\n/)
                while @input.match?(/\S+:[ ]+.*\n/) && @input.scan(/(\S+):[ ]+(.*)\n/)
                  key, value = @input[1].strip, @input[2].strip
                  if key == 'person'
                    @ast['name'] = value
                  elsif key == 'org'
                    if value =~ /org_name_hun:\s+(.*)\Z/
                      @ast['name'] = $1
                    elsif value =~ /org_name_eng:\s+(.*)\Z/
                      @ast['org'] = $1
                    elsif value != 'Private person'
                      contact['org'] = value
                    end
                  elsif @ast[key].nil?
                    @ast[key] = value
                  elsif @ast[key].is_a? Array
                    @ast[key] << value
                  else
                    @ast[key] = [@ast[key], value].flatten
                  end
                end
                true
              end
              false
            end

            def parse_contacts
              if @input.match?(/\n\S+:[ ]+.*\n/)
                while @input.match?(/\n\S+:[ ]+.*\n/)
                  @input.scan(/\n/)
                  parse_contact
                end
                true
              else
                false
              end
            end

            def parse_contact
              if @input.match?(/\S+:[ ]+.*\n/)
                contact ||= {}
                while @input.match?(/\S+:[ ]+.*\n/) && @input.scan(/(\S+):[ ]+(.*)\n/)
                  key, value = @input[1].strip, @input[2].strip
                  if key == 'hun-id'
                    a1 = contact['address'][1].split(/\s/)
                    zip = a1.shift
                    city = a1.join(' ')
                    # we should keep the old values if this is an already
                    # defined contact
                    if @ast[value].nil?
                      @ast[value] = {
                        "id" => value,
                        "name" => contact['name'],
                        "organization" => contact['org'],
                        "address" => contact['address'][0],
                        "city" => city,
                        "zip" => zip,
                        "country_code" => contact['address'][2],
                        "phone" => contact['phone'],
                        "fax" => contact['fax-no'],
                        "email" => contact['e-mail']
                      }
                    else
                      @ast[value]["id"] ||= value
                      @ast[value]["name"] ||= contact['name']
                      @ast[value]["organization"] ||= contact['org']
                      @ast[value]["address"] ||= contact['address'][0]
                      @ast[value]["city"] ||= city
                      @ast[value]["zip"] ||= zip
                      @ast[value]["country_code"] ||= contact['address'][2]
                      @ast[value]["phone"] ||= contact['phone']
                      @ast[value]["fax"] ||= contact['fax-no']
                      @ast[value]["email"] ||= contact['e-mail']
                    end
                    contact = {}
                  elsif key == 'person'
                    contact['name'] = value
                  elsif key == 'org'
                    if value =~ /org_name_hun:\s+(.*)\Z/
                      contact['name'] = $1
                    elsif value =~ /org_name_eng:\s+(.*)\Z/
                      contact['org'] = $1
                    else
                      contact['org'] = value
                    end
                  elsif key == 'address' && !contact['address'].nil?
                    contact['address'] = [contact['address'], value].flatten
                  else
                    contact[key] = value
                  end
                end
                true
              end
              false
            end

            def error(message)
              raise "#{message}: #{@input.peek(@input.string.length)}"
            end

        end
        
      end
      
    end
  end
end