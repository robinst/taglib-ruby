require File.join(File.dirname(__FILE__), 'helper')

class TestFile < Test::Unit::TestCase
  context "The sample.mp3 file" do
    setup do
      @mpeg_file = TagLib::MPEG::File.new("test/data/sample.mp3", false)
    end

    context "filename" do
      should "be the right name" do
        assert_equal 'test/data/sample.mp3', @mpeg_file.name
      end

      if HAVE_ENCODING
        should "have the right encoding" do
          assert_equal Encoding.find('filesystem'), @mpeg_file.name.encoding
        end
      end
    end
  end
end
