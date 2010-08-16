# -*- coding: utf-8 -*-


module Typedown2Blog
  begin
    glob = ARGV[0] || ENV['TYPEDOWN_MAIL_GLOB']
  end

  class Spec
    def self.setup &block
      instance_eval &block
    end


    def self.mail_defaults &blog
      Mail.defaults &block
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

