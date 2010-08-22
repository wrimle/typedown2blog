#!/usr/bin/env ruby

require 'fileutils'
require 'rubygems'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'typedown2blog'

include Typedown2Blog


config = YAML::load(File.open("config/config.yaml"))
Typedown2Blog::Spec::setup do
  delivery_method :smtp, config["smtp"]
end

mail = Mail.new do
  to config["test"]["secret_mail"]
  from config["test"]["mail_from"]
end

isFirst = true
ARGV.each do |filename|
  if isFirst
    mail.body File.read(filename)
    isFirst = false
  else
    mail.add_file filename
  end
end
mail.deliver!
