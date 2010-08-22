#!/bin/env ruby

require 'rubygems'
require 'daemons'
require 'log4r'
require 'log4r/outputter/syslogoutputter'

include Log4r


Daemons.run_proc('pop2blog.rb') do
  loop do
    sleep(5)
  end
end
