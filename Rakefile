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
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => [:compile, :test]

require 'yard'
YARD::Rake::YardocTask.new do |t|
  version = TagLib::Version::STRING
  t.options = ['--title', "taglib-ruby #{version}"]
end

# Change to Bundler::GemHelper.gemspec when it's released
$gemspec = Bundler.load_gemspec('taglib-ruby.gemspec')

FileList['tasks/**/*.rake'].each { |task| import task }
