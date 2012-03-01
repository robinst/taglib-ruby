require File.join(File.dirname(__FILE__), 'helper')

class TestID3v2Unicode < Test::Unit::TestCase
  context "The unicode.mp3 file" do
    setup do
      read_properties = false
      @file = TagLib::MPEG::File.new("test/data/unicode.mp3", read_properties)
    end

    should "have an ID3v2 tag" do
      assert_not_nil @file.id3v2_tag
    end

    if HAVE_ENCODING
      context "tag" do
        setup do
          @tag = @file.id3v2_tag
        end

        should "return strings in the right encoding" do
          assert_equal "UTF-8", @tag.title.encoding.to_s
        end

        should "convert strings to the right encoding" do
          # Unicode Snowman in UTF-16
          utf16_encoded = "\x26\x03"
          utf16_encoded.force_encoding("UTF-16BE")

          # It should be converted here
          @tag.title = utf16_encoded

          result = @tag.title

          # In order for == to work, they have to be in the same
          # encoding
          utf8_encoded = utf16_encoded.encode("UTF-8")
          assert_equal utf8_encoded, result
        end
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end
end
