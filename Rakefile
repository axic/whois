$:.unshift(File.dirname(__FILE__) + "/lib")

require 'whois'
require 'rubygems'
require 'rake'
require 'echoe'
begin
  require 'hanna/rdoctask'
  hanna = false
rescue LoadError
  require 'rake/rdoctask'
  hanna = true
end

# Common package properties
PKG_NAME    = ENV['PKG_NAME']    || Whois::GEM
PKG_VERSION = ENV['PKG_VERSION'] || Whois::VERSION
RUBYFORGE_PROJECT = 'whois'

if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end
 
 
Echoe.new(PKG_NAME, PKG_VERSION) do |p|
  p.author        = "Simone Carletti"
  p.email         = "weppos@weppos.net"
  p.summary       = "An intelligent pure Ruby WHOIS client and parser."
  p.url           = "http://www.ruby-whois.org"
  p.project       = RUBYFORGE_PROJECT
  p.description   = <<-EOD
    Whois is an intelligent WHOIS client and parser written in pure Ruby. \
    It can query registry data for IPv4, IPv6 and top level domains, \
    parse and convert responses into easy-to-use Ruby objects.
  EOD

  p.need_zip      = true

  p.development_dependencies += ["rake  0.8.7",
                                 "echoe 4.1",
                                 "mocha 0.9.8"]

  p.rdoc_options  = []
  p.rdoc_options << "--inline-source"
  p.rdoc_options << "-T hanna" if hanna
  p.rcov_options  = ["-Itest -x mocha,rcov,Rakefile"]
end


desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r whois.rb"
end

begin
  require 'code_statistics'
  desc "Show library's code statistics"
  task :stats do
    CodeStatistics.new(["Whois", "lib"],
                       ["Tests", "test"]).to_s
  end
rescue LoadError
  puts "CodeStatistics (Rails) is not available"
end

Dir["tasks/**/*.rake"].each do |file|
  load(file)
end
