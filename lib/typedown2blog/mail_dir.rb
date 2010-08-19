# -*- coding: utf-8 -*-

include Typedown2Blog

module Typedown2Blog
  class MailDir
    def initialize options = {}, &block
      @attributes = {
        :glob => "#{ENV['HOME']}/MailDir/new/*",
      }.merge(options)
      instance_eval &block if block_given?
    end


    def glob v = nil
      if v
        a[:glob] = v
      else
        a[:glob]
      end
    end


    def process(options = {}, &block)
      a = @attributes.merge(options)

      didWork = false
      Dir.glob(a[ :glob ]) do |filename|
        yield(File.read_binary(filename))
        FileUtils::rm(filename)
        didWork = true
      end

      didWork
    end

  end
end
