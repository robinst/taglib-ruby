require File.join(File.dirname(__FILE__), 'helper')

class TestID3v2UnknownFrames < Test::Unit::TestCase
  context "UnknownFrame" do
    setup do
      read_properties = false
      @file = TagLib::MPEG::File.new("test/data/sample.mp3", read_properties)
      @tag = @file.id3v2_tag
    end

    should "should be returned with correct class" do
      f = TagLib::ID3v2::UnknownFrame.new("TDAT")
      assert_not_nil f
      @tag.add_frame(f)
      frames = @tag.frame_list("TDAT")
      tdat = frames.first
      assert_not_nil tdat
      # By looking at ID alone, it would have returned a
      # TextIdentificationFrame. So make sure the correct
      # class is returned here, because it would result in
      # segfaults when calling methods on it.
      assert_equal TagLib::ID3v2::UnknownFrame, tdat.class
    end

    teardown do
      @file.close
      @file = nil
    end
  end
end
