require 'helper'
require 'typedown2blog'
require 'yaml'

include Typedown2Blog


class TestBlogPost < Test::Unit::TestCase
  context "BlogPost.new" do
    setup do
      @config = if(File.exists?("test/config.yaml"))
                  YAML.load_file("test/config.yaml")
                else
                  nil
                end

      config = @config
      Mail.defaults do
        case
        when config["smtp"] then
          delivery_method :smtp, { :smtp => "smtp.get.no" } #config["smtp"] 
        else
          delivery_method :test
        end
      end
    end

    should "should accept parameters from a yaml file" do
      assert_not_nil(@config, "needs a real mail account")

      blog_post = BlogPost.new @config['blog']
    end


    should "should post a message" do
      pending("needs a real mail account") unless @config
      c = File.read_binary("test/data/example.tpd")
      blog_post = BlogPost.new @config['blog']
      blog_post.typedown_body c
      blog_post.post!
    end
  end
end
