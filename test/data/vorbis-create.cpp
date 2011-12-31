#include <iostream>
#include <stdlib.h>

#include <taglib/taglib.h>
#include <taglib/vorbisfile.h>

using namespace TagLib;

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cout << "usage: " << argv[0] << " file.mp3" << std::endl;
    exit(1);
  }
  char *filename = argv[1];

  Vorbis::File file(filename);
  Ogg::XiphComment *tag = file.tag();

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

  file.save();
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
