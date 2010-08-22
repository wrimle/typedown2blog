# -*- coding: utf-8 -*-

include Typedown2Blog

module Typedown2Blog

  class Blog
    begin
      @mail_to = nil
      @mail_from = nil
      @format = nil
    end


    def self.setup &block
      instance_eval &block if block_given?
      self
    end


    def self.mail_to v = nil
      if v
        @mail_to = v
      else
        @mail_to
      end
    end


    def self.mail_to= v
      @mail_to = v
    end


    def self.mail_from v = nil
      if v
        @mail_from = v
      else
        @mail_from
      end
    end


    def self.mail_from= v
      @mail_from = v
    end


    def self.format v = nil
      if v
        @format = v
      else
        @format || "wordpress"
      end
    end

    def self.format= v
      @format = v
    end

    def self.post filename_or_hash
      mail = send("format_#{format}", filename_or_hash)
      mail.deliver!
      #puts mail.to_s
    end

    def self.post filename_or_hash
      mail = send("format_#{format}", filename_or_hash)
      mail.deliver!
      #puts mail.to_s
    end

    def self.format_wordpress filename_or_hash
      mail_to = @mail_to
      mail_from = @mail_from
      mail = Typedown2Blog::convert_mail(filename_or_hash) do |typedown|
        to mail_to
        from mail_from unless from

        typedown_root = Typedown::Section.sectionize(typedown, subject)
        text_part.body "#{typedown_root.body.to_html}\n\n"
      end
      mail
    end

    def self.format_blogger  filename_or_hash
      mail_to = @mail_to
      mail_from = @mail_from
      mail = Typedown2Blog::convert_mail filename_or_hash do |typedown|
        to mail_to
        from mail_from unless from

        typedown_root = Typedown::Section.sectionize(typedown, subject)
        text_part.body = "<html><body>#{typedown_root.body.to_html}</body></html>\n\n"
        text_part.content_type "text/html"
      end
      mail
    end
  end
end
