#!/bin/env ruby

require 'rubygems'
require 'mail'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'typedown2blog'
require 'secret_mail'


config = YAML::load(File.open("config/config.yaml"))


Typedown2Blog::Spec::setup do
  retriever_method :pop3, config["pop3"]
  delivery_method :smtp, config["smtp"]
end

SecretMail::MailAction.mail_domain config["secret_mail"]["mail_domain"]
ActiveRecord::Base.establish_connection(config["db"])


Spec::retriever.process do |popped|
  SecretMail::Controller.process Mail.new(popped) do |action, record, mail|
    blog_post = Typedown2Blog::BlogPost.new do 
      puts action
      case action.to_sym
      when :created then
        self.mail_to = message.from
        self.mail_from = record.secret_mail
        self.typedown_body = "! Your typedown2blog gateway\nrecord.secret_mail\n"
      when :mail_to_blogger then
        self.mail_to = record.params
        self.format = 'blogger'
        self.import_mail :content => popped
      when :mail_to_wordpress then
        self.mail_to = record.params
        self.format = 'wordpress'
        self.import_mail :content => popped
      end
    end
    puts blog_post.inspect
    blog_post.post!
  end
end
