#include <iostream>
#include <stdlib.h>

#include <taglib/taglib.h>
#include <taglib/mp4file.h>

#include "get_picture_data.cpp"

using namespace TagLib;

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cout << "usage: " << argv[0] << " file.m4a" << std::endl;
    exit(1);
  }
  char *filename = argv[1];

  MP4::File file(filename);
  MP4::Tag *tag = file.tag();

  tag->setTitle("Title");
  tag->setArtist("Artist");
  tag->setAlbum("Album");
  tag->setComment("Comment");
  tag->setGenre("Pop");
  tag->setYear(2011);
  tag->setTrack(7);

  ByteVector data = getPictureData("globe_east_90.jpg");
  MP4::CoverArt cover_art = MP4::CoverArt(MP4::CoverArt::JPEG, data);
  MP4::CoverArtList cover_art_list = MP4::CoverArtList();
  cover_art_list.append(cover_art);
  tag->itemListMap().insert("covr", MP4::Item(cover_art_list));

  file.save();
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
