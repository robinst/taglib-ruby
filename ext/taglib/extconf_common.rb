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
  error "You must have taglib installed in order to use taglib-ruby."
end

$CFLAGS << " -DSWIG_TYPE_TABLE=taglib"
