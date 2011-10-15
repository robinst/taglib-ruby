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
  gem.summary = %Q{Ruby interface for the taglib C++ library}
  gem.description = <<-DESC
Ruby interface for the taglib C++ library.

In contrast to other libraries, this one wraps the C++ API using SWIG,
not only the minimal C API. This means that all tags can be accessed.
  DESC
  gem.requirements = 'taglib (libtag1-dev in Debian/Ubuntu, taglib-devel in Fedora/RHEL)'
  gem.version = TagLib::Version::STRING
  gem.license = "MIT"
  gem.email = "robin@nibor.org"
  gem.homepage = "http://github.com/robinst/taglib-ruby"
  gem.authors = ["Robin Stocker"]
  gem.extensions = ['ext/taglib_base/extconf.rb',
                    'ext/taglib_mpeg/extconf.rb',
                    'ext/taglib_id3v2/extconf.rb']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/extensiontask'
Rake::ExtensionTask.new("taglib_base")
Rake::ExtensionTask.new("taglib_mpeg")
Rake::ExtensionTask.new("taglib_id3v2")

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

require 'yard'
YARD::Rake::YardocTask.new do |t|
  version = TagLib::Version::STRING
  t.options = ['--title', "taglib-ruby #{version}"]
end

FileList['tasks/**/*.rake'].each { |task| import task }
