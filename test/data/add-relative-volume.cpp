#include <iostream>
#include <stdlib.h>

#include <taglib/taglib.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>
#include <taglib/relativevolumeframe.h>

using namespace TagLib;

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cout << "usage: " << argv[0] << " file.mp3" << std::endl;
    exit(1);
  }
  char *filename = argv[1];

  MPEG::File file(filename);
  ID3v2::Tag *tag = file.ID3v2Tag(true);

  ID3v2::RelativeVolumeFrame *rv = new ID3v2::RelativeVolumeFrame();

  rv->setVolumeAdjustmentIndex(512);
  rv->setVolumeAdjustmentIndex(1024, ID3v2::RelativeVolumeFrame::Subwoofer);

  ID3v2::RelativeVolumeFrame::PeakVolume pv1;
  pv1.bitsRepresentingPeak = 8;
  pv1.peakVolume = "A"; // 0x41, 0b01000001
  rv->setPeakVolume(pv1);

  ID3v2::RelativeVolumeFrame::PeakVolume pv2;
  pv2.bitsRepresentingPeak = 4;
  pv2.peakVolume = "?"; // 0x3F, 0b00111111
  rv->setPeakVolume(pv2, ID3v2::RelativeVolumeFrame::Subwoofer);

  tag->addFrame(rv);
  file.save();
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
