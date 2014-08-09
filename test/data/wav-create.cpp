#include <taglib/taglib.h>
#include <taglib/wavfile.h>
#include <taglib/wavproperties.h>
#include <taglib/attachedpictureframe.h>

#include "get_picture_data.cpp"

using namespace TagLib;


int main(int argc, char **argv) {
  if (argc != 2) {
    std::cout << "usage: " << argv[0] << " file.wav" << std::endl;
    exit(1);
  }
  char *filename = argv[1];

  RIFF::WAV::File file(filename);
  ID3v2::Tag *tag = file.tag();

  tag->setArtist("WAV Dummy Artist Name");
  tag->setAlbum("WAV Dummy Album Title");
  tag->setTitle("WAV Dummy Track Title");
  tag->setTrack(5);
  tag->setYear(2014);
  tag->setGenre("Jazz");
  tag->setComment("WAV Dummy Comment");

  tag->removeFrames("APIC");

  ByteVector picture_data;
  ID3v2::AttachedPictureFrame *apic;

  picture_data = getPictureData("globe_east_540.jpg");
  apic = new ID3v2::AttachedPictureFrame();
  apic->setPicture(picture_data);
  apic->setMimeType("image/jpeg");
  apic->setType(ID3v2::AttachedPictureFrame::FrontCover);
  apic->setDescription("WAV Dummy Front Cover-Art");
  apic->setTextEncoding(String::UTF8);
  tag->addFrame(apic);

  picture_data = getPictureData("globe_east_90.jpg");
  apic = new ID3v2::AttachedPictureFrame();
  apic->setPicture(picture_data);
  apic->setMimeType("image/jpeg");
  apic->setType(ID3v2::AttachedPictureFrame::Other);
  apic->setDescription("WAV Dummy Thumbnail");
  apic->setTextEncoding(String::UTF8);
  tag->addFrame(apic);

  file.save();
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
