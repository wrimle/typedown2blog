# -*- coding: utf-8 -*-

require 'attachments'

include Typedown2Blog
module Typedown2Blog

  class BlogPost < Base
    attr_accessor :mail_from, :mail_to, :typedown_body, :format
    
    begin
      @formatters = {}
    end


    def initialize options = {}, &block
      @mail_to = nil
      @mail_from = nil
      @typedown_body = ""
      @format = nil
      @attachments = []

      options.each do |k, v|
        send("#{k}=", v)
      end

      instance_eval &block if block_given?
    end

    def self.add_formatter name, formatter
      @formatters[ name ] = formatter
    end


    def self.formatters
      @formatters
    end

    def add_attachment v
      @attachments << v
    end


    def post!
      mail_to = self.mail_to
      mail_from = self.mail_from
      mail_subject, mail_body, mail_content_type = self.format_body(self.typedown_body)

      mail_attachments = @attachments

      mail = Mail.new do
        from mail_from
        to mail_to
        subject mail_subject

        body mail_body
        content_type mail_content_type
        mail_attachments.each do |a|
          add_file a
        end
      end

      log.info(mail_subject + " delivered to " + mail_to)
      mail.deliver!
    end

    def import_mail filename_or_hash
      post = nil
      extract = Attachments::Extract.new [ "image/jpeg" ]
      begin
        extract.parse filename_or_hash
        self.mail_from = extract.from

        typedown_root = Typedown::Section.sectionize(extract.text_body, extract.subject)
        self.typedown_body = typedown_root.doc

        extract.files.each do |f|
          self.add_attachment f[:tmpfile] # f[:save_as], f[:mime_type
        end
      ensure
        extract.close
      end
    end

    protected
    def format_body typedown
      if(format)
        self.class.formatters[format].format typedown
      else
        doc = Typedown::Section.sectionize(typedown)
        body = "#{doc.body.to_html}\n\n"
        [ doc.title, body, "plain/text" ]
      end
    end

  end
end
