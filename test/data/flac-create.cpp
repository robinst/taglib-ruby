#include <iostream>
#include <stdlib.h>

#include <taglib/taglib.h>
#include <taglib/flacfile.h>
#include <taglib/xiphcomment.h>

#include "get_picture_data.cpp"

using namespace TagLib;

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cout << "usage: " << argv[0] << " file" << std::endl;
    exit(1);
  }
  char *filename = argv[1];

  FLAC::File file(filename);
  Ogg::XiphComment *tag = file.xiphComment(true);

  tag->setTitle("Title");
  tag->setArtist("Artist");
  tag->setAlbum("Album");
  tag->setComment("Comment");
  tag->setGenre("Pop");
  tag->setYear(2011);
  tag->setTrack(7);

  tag->addField("VERSION", "original");
  tag->addField("PERFORMER", "Performer");
  tag->addField("COPYRIGHT", "2011 Me, myself and I");
  tag->addField("LICENSE", "Any Use Permitted");
  tag->addField("ORGANIZATION", "Organization");
  tag->addField("DESCRIPTION", "Test file");
  tag->addField("LOCATION", "Earth");
  tag->addField("CONTACT", "Contact");

  tag->addField("MULTIPLE", "A");
  tag->addField("MULTIPLE", "B", false);

  FLAC::Picture *picture = new FLAC::Picture();

  picture->setType(FLAC::Picture::FrontCover);
  picture->setMimeType("image/jpeg");
  picture->setDescription("Globe");
  picture->setWidth(90);
  picture->setHeight(90);
  picture->setColorDepth(8);
  picture->setNumColors(0);

  ByteVector data = getPictureData("globe_east_90.jpg");
  picture->setData(data);

  file.addPicture(picture);

  file.save();
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
