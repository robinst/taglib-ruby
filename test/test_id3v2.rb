require 'helper'

class TestID3v2 < Test::Unit::TestCase
  context "The sample.mp3 file" do
    setup do
      read_properties = false
      file = TagLib::MPEG::File.new("test/data/sample.mp3", read_properties)
      @file = file
    end

    should "have a ID3v2 tag" do
      assert_not_nil @file.id3v2_tag
    end

    context "tag" do
      setup do
        @tag = @file.id3v2_tag
      end

      should "have basic properties" do
        assert_equal 'Dummy Title', @tag.title
        assert_equal 'Dummy Artist', @tag.artist
        assert_equal 'Dummy Album', @tag.album
        assert_equal 'Dummy Comment', @tag.comment
        assert_equal 'Pop', @tag.genre
        assert_equal 2000, @tag.year
        assert_equal 1, @tag.track
        assert_equal false, @tag.empty?
      end

      context "frames" do
        setup do
          @frames = @tag.frame_list
        end

        should "be complete" do
          assert_not_nil @frames
          assert_equal 9, @frames.size
          iterator = @frames.begin
          frame = iterator.value
          assert_equal "Dummy Title", frame.to_string
        end

        should "be enumerable" do
          ids = @frames.collect{ |frame| frame.id }
          assert_equal ["TIT2", "TPE1", "TALB", "TRCK", "TDRC",
                        "COMM", "COMM", "TCON", "TXXX"], ids
        end
      end

      context "TXXX frame" do
        setup do
          @txxx_frames = @tag.frame_list('TXXX')
        end

        should "should exist" do
          assert_equal 1, @txxx_frames.size
        end

        should "be convertable to its concrete type" do
          frame = @txxx_frames.begin.value
          txxx = frame.to_user_text_identification_frame
          assert_equal TagLib::ID3v2::UserTextIdentificationFrame, txxx.class
        end
      end
    end
  end
end
