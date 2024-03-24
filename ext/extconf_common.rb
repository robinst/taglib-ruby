# frozen-string-literal: true

require 'mkmf'

def error(msg)
  message "#{msg}\n"
  abort
end

if ENV.key?('TAGLIB_DIR') && !File.directory?(ENV['TAGLIB_DIR'])
  error 'When defined, the TAGLIB_DIR environment variable must point to a valid directory.'
end

# If specified, use the TAGLIB_DIR environment variable as the prefix
# for finding taglib headers and libs. See MakeMakefile#dir_config
# for more details.
dir_config('tag', (ENV['TAGLIB_DIR'] if ENV.key?('TAGLIB_DIR')))

# When compiling statically, -lstdc++ would make the resulting .so to
# have a dependency on an external libstdc++ instead of the static one.
unless $LDFLAGS.split(' ').include?('-static-libstdc++')
  error 'You must have libstdc++ installed.' unless have_library('stdc++')
end

unless have_library('tag')
  error <<~DESC
    You must have taglib installed in order to use taglib-ruby.

    Debian/Ubuntu: sudo apt-get install libtag1-dev
    Fedora/RHEL: sudo dnf install taglib-devel
    Brew: brew install taglib
    MacPorts: sudo port install taglib
  DESC
end

$CFLAGS << ' -DSWIG_TYPE_TABLE=taglib'
$CXXFLAGS += ' -std=c++17'

# Allow users to override the Ruby runtime's preferred CXX
RbConfig::MAKEFILE_CONFIG['CXX'] = ENV['TAGLIB_RUBY_CXX'] if ENV['TAGLIB_RUBY_CXX']
