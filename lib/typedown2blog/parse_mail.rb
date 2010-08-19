# -*- coding: utf-8 -*-

require 'attachments'
require 'typedown'

module Typedown2Blog
  def read_file filename
    f = File.new(filename, "rb")
    content = f.read()
    f.close()
    content
  end

  def convert_mail filename_or_hash, &block
    out = nil
    extract = Attachments::Extract.new [ "image/jpeg" ]
    begin
      out = Mail.new do
        extract.parse filename_or_hash
        from extract.from

        typedown_root = Typedown::Section.sectionize(extract.text_body, extract.subject)

        subject typedown_root.title
        text_part do
          charset = 'UTF-8'
          body "ahc" #typedown_root.body
        end

        extract.files.each do |f|
          data = read_file(f[:tmpfile])
          add_file(:filename => f[:save_as], :content =>  data )
          attachments[f[:save_as]][:mime_type] = f[:mime_type]

          #convert_to_multipart unless self.multipart?
          #add_multipart_mixed_header
          #attachments[f[:save_as]] = {
          #  :mime_type => f[:mime_type],
          #  :content =>  data,
          #}
        end

        if block_given?
          instance_exec typedown_root.body, &block
        end
      end
    ensure
      extract.close
    end
    out
  end


  def create_mail typedown_file, media_files = [], &block
    out = Mail.new do
      typedown = read_file(typedown_file)
      typedown_root = Typedown::Section.sectionize(typedown)
      subject typedown_root.title
      text_part do
        charset = 'UTF-8'
        body typedown_root.body
      end

      files.each do |f|
        content = read_file(f)

        add_file(:f, :content =>  content )
        attachments[f[:save_as]][:mime_type] = f[:mime_type]
      end

      if block_given?
        instance_eval &block
      end
    end
  end

end
