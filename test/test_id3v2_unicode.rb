require 'helper'

class TestID3v2Unicode < Test::Unit::TestCase
  context "The unicode.mp3 file" do
    setup do
      read_properties = false
      file = TagLib::MPEG::File.new("test/data/unicode.mp3", read_properties)
      @file = file
    end

    should "have an ID3v2 tag" do
      assert_not_nil @file.id3v2_tag
    end

    context "tag" do
      setup do
        @tag = @file.id3v2_tag
      end

      should "return strings in the right encoding" do
        if HAVE_ENCODING
          assert_equal "UTF-8", @tag.title.encoding.to_s
        end
      end
    end
  end
end
