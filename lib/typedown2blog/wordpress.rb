# -*- coding: utf-8 -*-

module Typedown2Blog
  def wordpress secret_mail, filename
    mail = Typedown2Blog::parse_mail filename do
      to secret_mail

      typedown = text_part.body.decoded
      typedown_root = Typedown::Section.sectionize(typedown, subject)
      text_part.body = "#{typedown_root.body.to_html}\n\n"

      deliver!
    end
  end


  def wordpress_glob secret_mail, glob_name
    parse_glob glob_name do |filename|
      wordpress secret_mail, filename
    end
  end
end
