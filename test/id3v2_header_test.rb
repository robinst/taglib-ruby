require File.join(File.dirname(__FILE__), 'helper')

class TestID3v2Header < Test::Unit::TestCase
  context "The sample.mp3 file" do
    setup do
      read_properties = false
      @file = TagLib::MPEG::File.new("test/data/sample.mp3", read_properties)
      @tag = @file.id3v2_tag
    end

    should "have a ID3v2 header" do
      assert_not_nil @tag.header
    end

    context "header" do
      setup do
        @header = @tag.header
      end

      should "have a major version" do
        assert_equal 3, @header.major_version
      end

      should "have a revision number" do
        assert_equal 0, @header.revision_number
      end

      should "have a tag size" do
        assert_equal 63478, @header.tag_size
      end

      should "not have a footer" do
        assert_equal false, @header.footer_present
      end

      should "not have an extended header" do
        assert_equal false, @header.extended_header
      end

      context "changing the major version" do

        setup do
          @header.major_version = 4
        end

        should "have a different major verson" do
          assert_equal 4, @header.major_version
        end

        teardown do
          @header.major_version = 3
        end
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end
end
