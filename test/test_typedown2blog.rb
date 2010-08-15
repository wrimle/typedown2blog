require 'helper'
require 'typedown2blog'

include Typedown2Blog

class TestTypedown2Blog < Test::Unit::TestCase
  context "Executes at all:" do
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

  context "" do
    setup do
      @mail = parse_mail "./test/data/mail_0002.eml"
    end

    teardown do
    end

    should "parse" do
      assert_nothing_raised do
      end
    end
  end
end
