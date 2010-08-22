# -*- coding: utf-8 -*-

require 'mail_processor'

module Typedown2Blog
  class Spec
    def self.setup &block
      instance_eval &block if block_given?
      self
    end

    def self.retriever_method method, options={}, &block
      @retriever = MailProcessor::Processor.new do
        retriever method, options, &block
      end
      @retriever
    end

    def self.retriever
      @retriever
    end

    def self.mail_defaults &block
      Mail.defaults &block
    end

    def self.delivery_method m, options= {}
      Mail.defaults do
        delivery_method m, options
      end
    end



    def self.glob v = nil
      if v
        @glob = v
      else
        @glob
      end
    end
  end
end
