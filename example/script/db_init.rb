#!/bin/env ruby

require 'rubygems'
require 'secret_mail'
require 'secret_mail/../../db/create_tables'
require 'fileutils'

config = YAML::load(File.open("config/config.yaml"))

db_file = config["db"]["database"]
file_exist = false
if File.exists?(db_file)
   puts "Db already exists"
   file_exist = true
   exit
end

SecretMail::MailAction.mail_domain config["secret_mail"]["mail_domain"]
ActiveRecord::Base.establish_connection(config["db"])
ActiveRecord::Base.connection

CreateTables.up
domain = SecretMail::MailAction.mail_domain


SecretMail::MailAction.new({
	:secret_mail => "blogger@#{domain}", 
	:action => "create",
	:params => "mail_to_blogger"
}).save


SecretMail::MailAction.new({
	:secret_mail => "wordpress@#{domain}", 
	:action => "create",
	:params => "mail_to_wordpress"
}).save


SecretMail::MailAction.new({
	:secret_mail => "posterous@#{domain}", 
	:action => "create",
	:params => "mail_to_wordpress"
}).save


SecretMail::MailAction.new({
        :secret_mail => config["test"]["secret_mail"],
	:action => "mail_to_wordpress",
        :from => config["test"]["mail_from"], 
	:params => config["test"]["mail_to"]
}).save
