# -*- coding: utf-8 -*-

require 'rubygems'
require 'log4r'

module Typedown2Blog
  include Log4r
  class UnkownRetrieverError < StandardError; end

  log = Log4r::Logger.new "Typedown2Blog"
  log.outputters = Log4r::Outputter.stdout

  class Base
    def self.log
      Log4r::Logger["Typedown2Blog"]
    end

    def log
      self.class.log
    end


    # Symbolizes keys from yaml hashes while merging
    def merge_to_attributes other
      h = @attributes
      other.each do |k, v|
        h[k.to_sym] = v
      end
      self
    end
  end
end


class File
  def self.read_binary filename
    f = File.new(filename, "rb")
    content = f.read()
    f.close()
    content
  end
end

