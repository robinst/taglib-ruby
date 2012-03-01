require File.join(File.dirname(__FILE__), 'helper')

class TestID3v2RelativeVolumeFrame < Test::Unit::TestCase
  context "The relative-volume.mp3 RVA2 frame" do
    setup do
      @file = TagLib::MPEG::File.new("test/data/relative-volume.mp3")
      @tag = @file.id3v2_tag
      @rv = @tag.frame_list('RVA2').first
    end

    should "exist" do
      assert_not_nil @rv
    end

    should "have channels" do
      expected = [TagLib::ID3v2::RelativeVolumeFrame::MasterVolume, TagLib::ID3v2::RelativeVolumeFrame::Subwoofer]
      assert_equal expected, @rv.channels
    end

    should "have volume adjustments" do
      assert_equal 512, @rv.volume_adjustment_index
      assert_equal 1.0, @rv.volume_adjustment
      assert_equal 1024, @rv.volume_adjustment_index(TagLib::ID3v2::RelativeVolumeFrame::Subwoofer)
      assert_equal 2.0, @rv.volume_adjustment(TagLib::ID3v2::RelativeVolumeFrame::Subwoofer)
    end

    should "have peak volumes" do
      master_pv = @rv.peak_volume
      assert_equal 8, master_pv.bits_representing_peak
      assert_equal 0b01000001.chr, master_pv.peak_volume

      subwoofer_pv = @rv.peak_volume(TagLib::ID3v2::RelativeVolumeFrame::Subwoofer)
      assert_equal 4, subwoofer_pv.bits_representing_peak
      assert_equal 0b00111111.chr, subwoofer_pv.peak_volume
    end

    should "accept new volume adjustments" do
      @rv.set_volume_adjustment_index(2048, TagLib::ID3v2::RelativeVolumeFrame::FrontCentre)
      assert_equal 2048, @rv.volume_adjustment_index(TagLib::ID3v2::RelativeVolumeFrame::FrontCentre)
      @rv.set_volume_adjustment(4.0, TagLib::ID3v2::RelativeVolumeFrame::FrontLeft)
      assert_equal 4.0, @rv.volume_adjustment(TagLib::ID3v2::RelativeVolumeFrame::FrontLeft)
    end

    should "accept new peak volumes" do
      pv = TagLib::ID3v2::PeakVolume.new
      assert_equal 0, pv.bits_representing_peak
      assert_equal "", pv.peak_volume
      pv.bits_representing_peak = 6
      pv.peak_volume = 0b110111.chr
      @rv.set_peak_volume(pv, TagLib::ID3v2::RelativeVolumeFrame::BackLeft)

      pv2 = @rv.peak_volume(TagLib::ID3v2::RelativeVolumeFrame::BackLeft)
      assert_equal 6, pv2.bits_representing_peak
      assert_equal 0b110111.chr, pv2.peak_volume
    end

    teardown do
      @file.close
      @file = nil
    end
  end
end
