# frozen-string-literal: true

require File.join(File.dirname(__FILE__), 'helper')
require 'fileutils'

class TestUnicodeFilename < Test::Unit::TestCase
  SRC_FILE = 'test/data/vorbis.oga'
  # That's "hello-" followed by "ni hao" in UTF-8
  DST_FILE = "test/data/hello-\xE4\xBD\xA0\xE5\xA5\xBD.oga".dup # mutable

  context 'TagLib::FileRef' do
    setup do
      DST_FILE.force_encoding('UTF-8') if HAVE_ENCODING
      FileUtils.cp SRC_FILE, DST_FILE
      @fileref = TagLib::FileRef.new(DST_FILE, false)
      @tag = @fileref.tag
    end

    should 'be possible to read' do
      assert_not_nil @tag
      assert_equal 'Title', @tag.title
    end

    teardown do
      @fileref.close
      FileUtils.rm DST_FILE
    end
  end
end
