# encoding: utf-8

require 'bundler/gem_tasks'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
end

task :default => [:compile, :test]

require 'yard'
YARD::Rake::YardocTask.new do |t|
  version = TagLib::Version::STRING
  t.options = ['--title', "taglib-ruby #{version}"]
end

$gemspec = Bundler::GemHelper.gemspec

import 'tasks/docs_coverage.rake'
import 'tasks/ext.rake'
import 'tasks/gemspec_check.rake'

# When importing swig.rake, the *_wrap.cxx files depend on being generated
# by Swig. Since the ExtensionTasks depend on the *_wrap.cxx files,
# compiling the extensions will trigger Swig, which is not desired as
# those files have already been generated and there's no reason to make
# Swig a variable of the CI. To prevent those dependencies, do not import
# swig.rake when running in Travis.
import 'tasks/swig.rake' unless ENV['TRAVIS'] == 'true'
