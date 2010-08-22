
module Typedown2Blog
  class BlogFormatter
    def initialize name = nil
      BlogPost.add_formatter(name || self.class.to_s, self)
    end

    def format_body typedown
      raise "Pleas subclass and override this method."
      [ "Subject", "Body", "mime/type" ]
    end
  end


  class HtmlTagsInText < BlogFormatter
    def format_body typedown
      doc = Typedown::Section.sectionize(typedown)
      body = "#{doc.body.to_html}\n\n"
      [ doc.title, body, "plain/text" ]
    end

    new "wordpress"
    new "posterous"
  end


  class HtmlDocument < BlogFormatter
    def format_body typedown
      doc = Typedown::Section.sectionize(typedown)
      body = "<html>\n<body>\n#{doc.body.to_html}\n</body>\n</html>\n\n"
      [ doc.title, body, "plain/text" ]
    end

    new "blogger"
  end

end
