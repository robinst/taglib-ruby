# Default opt dirs to help mkmf find taglib
configure_args = "--with-opt-dir=/usr/local:/opt/local:/sw "
ENV['CONFIGURE_ARGS'] = configure_args + ENV.fetch('CONFIGURE_ARGS', "")

require 'mkmf'

def error msg
  message msg + "\n"
  abort
end

dir_config('tag')

if not have_library('stdc++')
  error "You must have libstdc++ installed."
end

if not have_library('tag')
  error <<-DESC
You must have taglib installed in order to use taglib-ruby.

Debian/Ubuntu: sudo apt-get install libtag1-dev
Fedora/RHEL: sudo yum install taglib-devel
Brew: brew install taglib
MacPorts: sudo port install taglib
DESC
end

$CFLAGS << " -DSWIG_TYPE_TABLE=taglib"
