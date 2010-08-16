# -*- coding: utf-8 -*-

require 'attachments'
require 'typedown'

module Typedown2Blog

  def parse_mail filename, &block
    out = nil
    extract = Attachments::Extract.new [ "image/jpeg" ]
    begin
      out = Mail.new do
        extract.parse filename
        from extract.from

        typedown_root = Typedown::Section.sectionize(extract.text_body, extract.subject)

        subject typedown_root.title
        text_part do
          charset = 'UTF-8'
          body typedown_root.body
        end

        extract.files.each do |f|
          file = File.new(f[:tmpfile], "rb")
          data = file.read()
          file.close()

          #add_file(:filename => f[:save_as], :content =>  data )
          #attachments[f[:save_as]][:mime_type] = f[:mime_type]

          convert_to_multipart unless self.multipart?
          add_multipart_mixed_header          
          attachments[f[:save_as]] = {
            :mime_type => f[:mime_type],
            :content =>  data,
          }
        end

        if block_given?
          instance_eval &block
        end
      end
    ensure
      extract.close
    end
    out
  end


  def send_to_blog filename, secret_mail
    mail = Typedown2Blog::parse_mail filename do
      to secret_mail

      typedown = text_part.body.decoded
      typedown_root = Typedown::Section.sectionize(typedown, subject)
      text_part.body = "#{typedown_root.body.to_html}\n\n"
    end
    mail.deliver!
  end



  def parse_glob glob_name, &block
    didWork = false
    Dir.glob(glob_name) do |filename|
      block.call filename
      didWork = true
    end
  
    didWork
  end

end
