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

    def add_attachment options = {}
      options[:content] = File.read_binary(options[:tmpfile]) unless options[:content]
      @attachments << options
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

        if mail_attachments.length == 0
          body mail_body
          content_type mail_content_type
        else
          text_part do
            self.charset = "UTF-8"
            body mail_body
          end
        end

        mail_attachments.each do |a|
          add_file(:filename => a[:save_as], :content => a[:content])
          attachments[a[:save_as]][:content_type] = a[:mime_type]
        end

        text_part.body = mail_body
        text_part.content_type mail_content_type
      end

      log.info((mail_subject || "(No subject)") + " delivered to " + (mail_to || "(nobody)"))
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
          self.add_attachment f
        end
      ensure
        extract.close
      end
    end

    protected
    def format_body typedown
      if(format)
        self.class.formatters[format].format_body typedown
      else
        doc = Typedown::Section.sectionize(typedown)
        body = "#{doc.body.to_html}\n\n"
        [ doc.title, body, "plain/text" ]
      end
    end

  end
end
