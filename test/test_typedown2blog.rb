require 'helper'
require 'typedown2blog'

include Typedown2Blog

class TestTypedown2Blog < Test::Unit::TestCase
  context "Parser" do
    should "parse mail_0001 without raising exceptions" do
      assert_nothing_raised do
        parse_mail "./test/data/mail_0001.eml"
      end
    end

    should "parse mail_0002 without raising exceptions" do
      assert_nothing_raised do
        mail = parse_mail "./test/data/mail_0002.eml"
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
      original_image = File.read("./test/data/mail_0002.jpg")
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
        Blog.post "rune@epubify.com", "./test/data/mail_0002.eml"
      end
    end

  end
end
