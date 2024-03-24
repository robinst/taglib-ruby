# frozen-string-literal: true

taglib_dir = ENV['TAGLIB_DIR']

unless taglib_dir
  # Default opt dirs to help mkmf find taglib
  opt_dirs = ['/usr/local', '/opt/local', '/sw']
  
  # Heroku vendor dir
  vendor = ENV.fetch('GEM_HOME', '')[/^[^ ]*\/vendor\//]
  opt_dirs << "#{vendor}taglib" if vendor
  opt_dirs_joined = opt_dirs.join(':')
  
  configure_args = "--with-opt-dir=#{opt_dirs_joined} "
  ENV['CONFIGURE_ARGS'] = configure_args + ENV.fetch('CONFIGURE_ARGS', '')
end

require 'mkmf'

def error(msg)
  message "#{msg}\n"
  abort
end

if taglib_dir && !File.directory?(taglib_dir)
  error 'When defined, the TAGLIB_DIR environment variable must point to a valid directory.'
end

# If specified, use the TAGLIB_DIR environment variable as the prefix
# for finding taglib headers and libs. See MakeMakefile#dir_config
# for more details.
dir_config('tag', taglib_dir)

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

# Allow users to override the Ruby runtime's preferred CXX
RbConfig::MAKEFILE_CONFIG['CXX'] = ENV['TAGLIB_RUBY_CXX'] if ENV['TAGLIB_RUBY_CXX']
