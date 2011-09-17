require 'helper'

class TestID3v2Memory < Test::Unit::TestCase

  N = 1000

  context "TagLib::ID3v2" do
    setup do
      @file = TagLib::MPEG::File.new("test/data/sample.mp3", false)
      @tag = @file.id3v2_tag
      @apic = @tag.frame_list("APIC").first
    end

    should "not corrupt memory with FrameList" do
      N.times do
        @tag.frame_list
      end
    end

    should "not corrupt memory with ByteVector" do
      data = nil
      N.times do
        data = @apic.picture
      end
      N.times do
        @apic.picture = data
      end
    end

    should "not corrupt memory with StringList" do
      txxx = @tag.frame_list('TXXX').first
      N.times do
        txxx.field_list
      end
      N.times do
        txxx.field_list = ["one", "two", "three"]
      end
    end

    should "not segfault when tag is deleted along with file" do
      @file = nil
      begin
        N.times do
          GC.start
          @tag.title
        end
      rescue => e
        assert_equal "ObjectPreviouslyDeleted", e.class.to_s
      else
        raise "GC did not delete file, unsure if test was successful."
      end
    end
  end
end
