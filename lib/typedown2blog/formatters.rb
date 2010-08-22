
module Typedown2Blog
  class BlogFormatter
    def initialize name = nil
      BlogPost.add_formatter(name || self.class.to_s, self)
    end

    def format typedown
      raise "Pleas subclass and override this method."
      [ "Subject", "Body", "mime/type" ]
    end
  end

  class Wordpress < BlogFormatter
    def format typedown
      doc = Typedown::Section.sectionize(typedown)
      body = "#{doc.body.to_html}\n\n"
      [ doc.title, body, "plain/text" ]
    end

    new
  end

  class Blogger < BlogFormatter
    def format typedown
      doc = Typedown::Section.sectionize(typedown)
      body = "<html>\n<body>\n#{doc.body.to_html}\n</body>\n</html>\n\n"
      [ doc.title, body, "plain/text" ]
    end

    new
  end

end
