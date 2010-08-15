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
          body typedown_root.doc
        end

        #html_part do
        #  b = "#{typedown_root.body.to_html}\n"
        #  body b
        #end

        extract.files.each do |f|
          file = File.new(f[:tmpfile], "rb")
          data = file.read()
          file.close()

          part = Mail::Part.new({:content_type => f[:mime_type],
                                  :body => data})
          add_part(part)
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



  def parse_glob glob_name, &block
    didWork = false
    Dir.glob(glob_name) do |filename|
      block.call filename
      didWork = true
    end
  
    didWork
  end

end
