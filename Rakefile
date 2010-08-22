require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "typedown2blog"
    gem.summary = %Q{Email gateway for reformatting typedown documents before forwarding to blog}
    gem.description = %Q{The script will forward to the blog via a Mail2Blog interface.}
    gem.email = "rune@epubify.com"
    gem.homepage = "http://github.com/wrimle/typedown2blog"
    gem.authors = ["Rune Myrland"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_dependency('attachments','>= 0.0.11')
    gem.add_dependency('typedown','>= 0.0.5')
    gem.add_dependency('mail_processor','>= 0.0.2')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "typedown2blog #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
