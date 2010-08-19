# -*- coding: utf-8 -*-

include Typedown2Blog;

module Typedown2Blog

  class Pop3

    def initialize options = {}, &block
      @attributes = {
        :address => "pop.gmail.com",
        :port => 995, # 110,
        :username => nil,
        :password => nil,
        :use_ssl => true, # false
      }.merge(options)
      instance_eval &block if block_given?
    end

    def address v = nil
      if v
        @attributes[:address] = v
      else
        @attributes[:address]
      end
    end

    def port v = nil
      if v
        @attributes[:port] = v
      else
        @attributes[:port]
      end
    end

    def username v = nil
      if v
        @attributes[:username] = v
      else
        @attributes[:username]
      end
    end

    def password v = nil
      if v
        @attributes[:password] = v
      else
        @attributes[:password]
      end
    end

    def use_ssl?
      @attributes[:use_ssl]
    end

    def use_ssl v = nil
      if v
        @attributes[:use_ssl] = v
      else
        @attributes[:use_ssl]
      end
    end


    def process(options = {}, &block)
      a = @attributes.merge(options)

      didWork = false
      Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if a[:use_ssl]
      pop = Net::POP3.new(a[:address], a[:port])
      pop.start(a[:username], a[:password])
      if pop.mails.empty?
        puts 'No mail.'
      else
        pop.each_mail do |m|
          yield m.pop
          m.delete
          puts "#{pop.mails.size} mails popped."
        end
        pop.finish
        didWork = true
      end

      didWork
    end
  end
end
