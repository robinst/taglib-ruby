# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/taglib/version.rb'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "taglib-ruby"
  gem.summary = %Q{Ruby interface for the complete taglib C++ library}
  gem.description = File.read('README.md')
  gem.version = TagLib::Version::STRING
  gem.license = "MIT"
  gem.email = "robin@nibor.org"
  gem.homepage = "http://github.com/robinst/taglib-ruby"
  gem.authors = ["Robin Stocker"]
  gem.extensions = FileList['ext/taglib/*/extconf.rb'].to_a
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = TagLib::Version::STRING

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "taglib-ruby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
