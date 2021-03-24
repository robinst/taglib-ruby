# frozen-string-literal: true

require 'bundler/gem_tasks'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
end

task default: %i[compile test]

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
# by Swig. Since the ExtensionTasks depend on the *_wrap.cxx files,
# compiling the extensions will trigger Swig, which is not desired as
# those files have already been generated and there's no reason to make
# Swig a variable of the CI. The environment variable can be set to
# prevent running swig.
import 'tasks/swig.rake' unless ENV['SKIP_SWIG'] == 'true'
