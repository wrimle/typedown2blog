# -*- coding: utf-8 -*-


module Typedown2Blog
  class Spec
    def self.setup &block
      instance_eval &block if block_given?
      self
    end


    def self.blog &block
      Blog.setup &block
    end


    def self.mail_dir &block
      @retreiver = MailDir.new &block if block_given?
    end


    def self.pop3 &block
      if block_given?
        @retreiver = Pop3.new &block 
      else
        @retreiver = Pop3.new
      end
    end


    def self.retreiver_method v, &block
      if respond_to?(v)
        send(v, &block)
      end
      @retreiver
    end

    def self.retreiver
      @retreiver
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
