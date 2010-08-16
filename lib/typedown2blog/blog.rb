# -*- coding: utf-8 -*-

module Typedown2Blog
  class Blog
    begin
      @email = nil
    end


    def self.setup &block
      instance_eval &block
    end


    def self.email v = nil
      if v
        @email = v
      else
        @email
      end
    end


    def self.email= v
      @email = v
    end


    def self.post filename
      mail_to = @email
      mail = Typedown2Blog::parse_mail filename do
        to mail_to

        typedown = text_part.body.decoded
        typedown_root = Typedown::Section.sectionize(typedown, subject)
        text_part.body = "#{typedown_root.body.to_html}\n\n"
      end
      mail.deliver!
    end
  end
end
