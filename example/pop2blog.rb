#!/bin/env ruby

require 'rubygems'
require 'mail'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'typedown2blog'

Typedown2Blog::Spec::setup do
  blog do
    email 'you_secret_blog_mail@example.com'
    format 'wordpress' # Also for posterous. Adds html formatting tags inside text/plain
    # format 'blogger' # Converts to text/html
  end

  # Pop3 account
  retreiver_method :pop3 do
    address "pop.example.com"
    username "your_mail@example.com"
    password "**secret**"
  end

  # This is passed on to the "mail" gem's Mail#delivery_method
  delivery_method :smtp, {
    :address => 'smtp.example.com',
    :port => 25,
    :domain => 'example.com',
    :user_name            => 'you',
    :password             => 'your_password',
    :authentication       => :plain,
  }
end


Spec::retreiver.process do |popped|
  # You may want to set these here if want to forward to multiple blogs
  # Typedown2Blog::Blog.format = "blogger|wordpress"
  # Typedown2Blog::Blog.mail_to = ""
  Typedown2Blog::Blog.post(:content => popped)
end
