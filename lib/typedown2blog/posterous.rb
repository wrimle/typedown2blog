# -*- coding: utf-8 -*-

module Typedown2Blog
  def posterous filename
    mail = Typedown2Blog::parse_mail filename do
      to 'post@posterous.com'

      typedown = text_part.body.decoded
      typedown_root = Typedown::Section.sectionize(typedown, subject)
      text_part.body = "<markdown>\n#{typedown_root.body.to_markdown}\n</markdown>\n"

      deliver!
    end
  end


  def posterous_glob glob_name
    parse_glob glob_name do |filename|
      posterous filename
    end
  end
end
