#!/usr/bin/env ruby

require 'fileutils'
require 'rubygems'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'typedown2blog'

include Typedown2Blog


config = YAML::load(File.open("config/config.yaml"))

Typedown2Blog::Spec::setup do
  retriever_method :pop3, config["pop3"]
  delivery_method :smtp, config["smtp"]
end

post = BlogPost.new config["blog_post"]

isFirst = true
ARGV.each do |filename|
  if isFirst
    post.typedown_body = File.read(filename)
    isFirst = false
  else
    post.add_attachment filename
  end
end
post.post!
