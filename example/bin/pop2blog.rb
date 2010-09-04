#!/bin/env ruby

require 'rubygems'
# from 'mail' gem
require 'mail'
# from 'secret_mail' gem
require 'secret_mail'
# from 'uuidtools' gem
require 'uuidtools'
# from 'log4r' gem
require 'log4r'
require 'log4r/outputter/syslogoutputter'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'typedown2blog'

include Log4r

log = Log4r::Logger.new("pop2blog")
outputter = Outputter.stdout
#outputter = Log4r::FileOutputter.new "pop2blog", { :filename => "pop2blog.log" }
#outputter = Log4r::SyslogOutputter.new "pop2blog"
Log4r::Logger[ "pop2blog" ].outputters = outputter
Log4r::Logger[ "Typedown2Blog" ].outputters = outputter
Log4r::Logger[ "MailProcessor" ].outputters = outputter

config = YAML::load(File.open("config/config.yaml"))

Typedown2Blog::Spec::setup do
  retriever_method :pop3, config["pop3"]
  delivery_method :smtp, config["smtp"]
end

SecretMail::MailAction.mail_domain config["secret_mail"]["mail_domain"]
ActiveRecord::Base.establish_connection(config["db"])


errorCount = 0
loop do
  begin
    didWork = Spec::retriever.process do |popped|
      begin
        SecretMail::Controller.process Mail.new(popped) do |action, record, mail|
          blog_post = Typedown2Blog::BlogPost.new do 
            case action.to_sym
            when :created then
              self.mail_to = mail.from[0]
              self.mail_from = record.secret_mail
              self.typedown_body = "! Your typedown2blog gateway\n#{record.secret_mail}\n"
              self.format = 'blogger'
            when :mail_to_blogger then
              self.mail_to = record.params
              self.format = 'blogger'
              self.import_mail :mail => mail
            when :mail_to_wordpress then
              self.mail_to = record.params
              self.format = 'wordpress'
              self.import_mail :mail => mail
            else
              raise "Unsupported action: " + action.to_s
            end
          end
          blog_post.post!
        end
      rescue => err
        now = Time.now.strftime("%Y%m%d-%H%M%S")
        uuid = UUIDTools::UUID.random_create.to_s
        filename = "failed/#{now}-#{uuid}"
        log.error filename + ", " + err.message
        f = File.new(filename, "wb")
        f.write(popped)
        f.close()
        f = File.new(filename + ".error", "wb")
        f.write("#{err.message}\n#{err.backtrace.join("\n")}")
        f.close()
      end
    end
    sleep(10) unless(didWork)
    errorCount = 0
  rescue => err
    log.error "#{err.message}\n#{err.backtrace.join("\n")}"

    errorCount += 1
    seconds = [15 + errorCount * errorCount, 5 * 60].min
    sleep(seconds)
  end
end
