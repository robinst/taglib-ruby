# frozen-string-literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'extconf_common'

create_makefile('taglib_id3v1')
