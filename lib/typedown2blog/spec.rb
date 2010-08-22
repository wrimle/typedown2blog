# -*- coding: utf-8 -*-

require 'mail_processor'

module Typedown2Blog
  def symbolize_keys(hash)
    hash.inject({}){|result, (key, value)|  
      new_key = case key  
                when String then key.to_sym  
                else key  
                end  
      new_value = case value  
                  when Hash then symbolize_keys(value)  
                  else value  
                  end  
      result[new_key] = new_value  
      result  
    }  
  end


  class Spec
    def self.setup &block
      instance_eval &block if block_given?
      self
    end

    def self.retriever_method method, options={}, &block
      @retriever = MailProcessor::Processor.new do
        retriever method, symbolize_keys(options), &block
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
        delivery_method m, symbolize_keys(options)
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
