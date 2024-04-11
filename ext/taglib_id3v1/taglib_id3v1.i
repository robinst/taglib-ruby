%module "TagLib::ID3v1"
%{
#include <taglib/id3v1tag.h>
#include <taglib/id3v1genres.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%include <taglib/id3v1tag.h>

%typemap(out) TagLib::ID3v1::GenreMap {
  $result = taglib_id3v1_genre_map_to_ruby_hash($1);
}

%include <taglib/id3v1genres.h>

%{
VALUE taglib_id3v1_genre_map_to_ruby_hash(const TagLib::ID3v1::GenreMap &map) {
  VALUE hsh = rb_hash_new();
  for (TagLib::ID3v1::GenreMap::ConstIterator it = map.begin(); it != map.end(); it++) {
    rb_hash_aset(hsh,
                 taglib_string_to_ruby_string(it->first),
                 INT2NUM(it->second));
  }
  return hsh;
}
%}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
