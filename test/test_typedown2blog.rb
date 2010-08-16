require 'helper'
require 'typedown2blog'

include Typedown2Blog

class TestTypedown2Blog < Test::Unit::TestCase
  context "Parser" do
    should "parse test mails without raising exceptions" do
      assert_nothing_raised do
        Dir.glob("./test/data/mail_*.eml") do |filename|
          parse_mail "./test/data/mail_0001.eml"
        end
      end
    end
  end

  context "Attached image" do
    setup do
      @mail = parse_mail "./test/data/mail_0002.eml"
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
    should "parse mail_0002 without raising exceptions" do
      assert_nothing_raised do
        Blog.setup do
          email "rune@epubify.com"
        end
        #Blog.post "./test/data/mail_0002.eml"
      end
    end

  end
end
