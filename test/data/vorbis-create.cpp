#include <iostream>
#include <cstdlib>

#include <taglib/taglib.h>
#include <taglib/vorbisfile.h>

#include "get_picture_data.cpp"

using namespace TagLib;

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cerr << "usage: " << argv[0] << " file.oga" << std::endl;
    return EXIT_FAILURE;
  }

  char *filename = argv[1];

  Vorbis::File file(filename);
  Ogg::XiphComment *tag = file.tag();

  tag->removeAllFields();
  tag->removeAllPictures();

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

  const ByteVector data = getPictureData("globe_east_90.jpg");
  if (data.isEmpty()) {
    std::cerr << "failed to get picture data" << std::endl;
    return EXIT_FAILURE;
  }

  FLAC::Picture picture;
  picture.setType(FLAC::Picture::FrontCover);
  picture.setMimeType("image/jpeg");
  picture.setDescription("Globe");
  picture.setWidth(90);
  picture.setHeight(90);
  picture.setColorDepth(24);
  picture.setNumColors(0);
  picture.setData(data);

  tag->addField("METADATA_BLOCK_PICTURE", picture.render().toBase64());

  file.save();

  return EXIT_SUCCESS;
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
