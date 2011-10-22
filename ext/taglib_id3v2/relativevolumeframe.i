%rename("bits_representing_peak") TagLib::ID3v2::PeakVolume::bitsRepresentingPeak;
%rename("peak_volume") TagLib::ID3v2::PeakVolume::peakVolume;

%rename("set_volume_adjustment") TagLib::ID3v2::RelativeVolumeFrame::setVolumeAdjustment;
%rename("set_volume_adjustment_index") TagLib::ID3v2::RelativeVolumeFrame::setVolumeAdjustmentIndex;
%rename("set_peak_volume") TagLib::ID3v2::RelativeVolumeFrame::setPeakVolume;

struct TagLib::ID3v2::PeakVolume {
  unsigned char bitsRepresentingPeak;
  TagLib::ByteVector peakVolume;
};

%nestedworkaround TagLib::ID3v2::RelativeVolumeFrame::PeakVolume;

%{
namespace TagLib {
  namespace ID3v2 {
    typedef RelativeVolumeFrame::PeakVolume PeakVolume;
  }
}
%}

%typemap(out) TagLib::List<TagLib::ID3v2::RelativeVolumeFrame::ChannelType> {
  VALUE ary = rb_ary_new2($1.size());
  for (TagLib::List<TagLib::ID3v2::RelativeVolumeFrame::ChannelType>::ConstIterator it = $1.begin();
       it != $1.end(); it++) {
    VALUE ct = INT2NUM(*it);
    rb_ary_push(ary, ct);
  }
  $result = ary;
}

%include <taglib/relativevolumeframe.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
