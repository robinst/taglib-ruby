require 'rubygems'
require 'rake'

FILES = FileList[
  'Rakefile',
  'ext/taglib/Rakefile',
  'ext/taglib/*.rb',
  'ext/taglib/*/*.{rb,i,cxx}',
  'lib/**/*.rb',
  'test/*.rb'
]

VERSION = File.read('lib/taglib.rb')[/VERSION = '(.*)'/, 1]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "taglib-ruby"
    gem.summary = %Q{Ruby interface for the complete taglib C++ library}
    gem.description = File.read('README.rdoc')
    gem.version = VERSION
    gem.email = "robin@nibor.org"
    gem.homepage = "http://github.com/robinst/taglib-ruby"
    gem.authors = ["Robin Stocker"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.extensions = FileList['ext/taglib/*/extconf.rb'].to_a
    gem.files = FILES.to_a
  end
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
  version = VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "taglib-ruby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
