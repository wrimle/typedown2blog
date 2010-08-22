require 'helper'
require 'typedown2blog'

include Typedown2Blog

class TestTypedown2Blog < Test::Unit::TestCase
  context "Parser" do
    should "parse test mails without raising exceptions" do
      Dir.glob("./test/data/mail_*.eml") do |filename|
        assert_nothing_raised do
          convert_mail filename
        end
      end
    end
  end

  context "Attached image" do
    setup do
      @mail = convert_mail "./test/data/mail_0002.eml"
    end

    teardown do
    end

    should "be same as original image" do
      file = File.new("./test/data/mail_0002.jpg", "rb")
      original_image = file.read()
      file.close()

      attached_image = @mail.parts[1].body.decoded

      assert(original_image == attached_image)
    end
  end

  context "Blog" do
    setup do
      Spec.setup do
        blog do
          mail_to "test@wrimle.com"
          #format "wordpress"
          #format "blogger"
        end
        mail_defaults do 
          delivery_method :test
        end
      end
    end

    should "post mails without raising exceptions" do
      Spec.setup.blog do
        format "wordpress"
      end

      Dir.glob("./test/data/*.eml") do |filename|
        assert_nothing_raised do
          Blog.post filename
        end
      end
    end

    should "post mails in blogger formatword without raising exceptions" do
      Spec.setup.blog do
        format "wordpress"
      end

      Dir.glob("./test/data/*.eml") do |filename|
        assert_nothing_raised do
          Blog.post filename
        end
      end
    end
  end

end
