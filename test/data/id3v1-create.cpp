#include <iostream>
#include <cstdlib>

#include <taglib/taglib.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v1tag.h>

using namespace TagLib;

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cerr << "usage: " << argv[0] << " file.mp3" << std::endl;
    return EXIT_FAILURE;
  }

  char *filename = argv[1];

  MPEG::File file(filename);
  ID3v1::Tag *tag = file.ID3v1Tag(true);

  tag->setTitle("Title");
  tag->setArtist("Artist");
  tag->setAlbum("Album");
  tag->setComment("Comment");
  tag->setGenre("Pop");
  tag->setYear(2011);
  tag->setTrack(7);

  file.save(MPEG::File::ID3v1);

  return EXIT_SUCCESS;
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
