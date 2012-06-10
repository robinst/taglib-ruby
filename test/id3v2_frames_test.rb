require File.join(File.dirname(__FILE__), 'helper')

class TestID3v2Frames < Test::Unit::TestCase
  context "The sample.mp3 file's frames" do
    setup do
      read_properties = false
      # It's important that file is an instance variable, otherwise the
      # tag would get garbage collected along with the file, even if tag
      # itself would still be reachable. The reason is because
      # TagLib::MPEG::File owns the TagLib::ID3v2::Tag and automatically
      # deletes it in its destructor.
      @file = TagLib::MPEG::File.new("test/data/sample.mp3", read_properties)
      picture_file = File.open("test/data/globe_east_540.jpg", "rb") do |f|
        @picture_data = f.read
      end
      @tag = @file.id3v2_tag
      @frames = @tag.frame_list
    end

    should "be complete" do
      assert_not_nil @frames
      assert_equal 11, @frames.size
      frame = @frames.first
      assert_equal "Dummy Title", frame.to_string
    end

    should "be enumerable" do
      ids = @frames.collect { |frame| frame.frame_id }
      assert_equal ["TIT2", "TPE1", "TALB", "TRCK", "TDRC",
                    "COMM", "COMM", "TCON", "TXXX", "COMM", "APIC"], ids
    end

    should "be automatically converted" do
      apic = @tag.frame_list('APIC').first
      comm = @tag.frame_list('COMM').first
      tit2 = @tag.frame_list('TIT2').first
      txxx = @tag.frame_list('TXXX').first
      assert_equal TagLib::ID3v2::AttachedPictureFrame, apic.class
      assert_equal TagLib::ID3v2::CommentsFrame, comm.class
      assert_equal TagLib::ID3v2::TextIdentificationFrame, tit2.class
      assert_equal TagLib::ID3v2::UserTextIdentificationFrame, txxx.class
    end

    should "not fail for nil String" do
      assert_equal [], @tag.frame_list(nil)
    end

    should "be removable" do
      assert_equal 11, @tag.frame_list.size
      tit2 = @tag.frame_list('TIT2').first
      @tag.remove_frame(tit2)
      assert_equal 10, @tag.frame_list.size
      begin
        tit2.to_string
        flunk("Should have raised ObjectPreviouslyDeleted.")
      rescue => e
        assert_equal "ObjectPreviouslyDeleted", e.class.to_s
      end
    end

    should "be removable by ID" do
      frames = @tag.frame_list
      @tag.remove_frames('COMM')
      tit2 = frames.find { |f| f.frame_id == 'TIT2' }
      # Other frames should still be accessible
      assert_equal "Dummy Title", tit2.to_s
    end

    context "APIC frame" do
      setup do
        @apic = @tag.frame_list('APIC').first
      end

      should "have a type" do
        assert_equal TagLib::ID3v2::AttachedPictureFrame::FrontCover, @apic.type
      end

      should "have a description" do
        assert_equal "Blue Marble", @apic.description
      end

      should "have a mime type" do
        assert_equal "image/jpeg", @apic.mime_type
      end

      should "have picture bytes" do
        assert_equal 61649, @apic.picture.size
        if HAVE_ENCODING
          assert_equal @picture_data.encoding, @apic.picture.encoding
        end
        assert_equal @picture_data, @apic.picture
      end
    end

    context "TXXX frame" do
      setup do
        @txxx_frame = @tag.frame_list('TXXX').first
      end

      should "exist" do
        assert_not_nil @txxx_frame
      end

      should "have to_s" do
        expected = "[MusicBrainz Album Id] MusicBrainz Album Id 992dc19a-5631-40f5-b252-fbfedbc328a9"
        assert_equal expected, @txxx_frame.to_string
      end

      should "have field_list" do
        assert_equal ["MusicBrainz Album Id", "992dc19a-5631-40f5-b252-fbfedbc328a9"], @txxx_frame.field_list
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end
end
