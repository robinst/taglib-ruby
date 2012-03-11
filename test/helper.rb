require 'rubygems'
require 'test/unit'
require 'shoulda-context'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'taglib'

HAVE_ENCODING = !RUBY_VERSION.start_with?("1.8")
