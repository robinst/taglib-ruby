%module "TagLib::MP4"
%{
#include <taglib/taglib.h>
#include <taglib/mp4file.h>
#include <taglib/mp4properties.h>
#include <taglib/mp4tag.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%ignore TagLib::Map::operator[];
%ignore TagLib::Map::operator=;
%rename("contains?") contains;
%include <taglib/tmap.h>

%include <taglib/tiostream.h>

namespace TagLib {
  namespace MP4 {
    class Item;
    class Properties;
  }
}

%include <taglib/mp4properties.h>
%include <taglib/mp4tag.h>

%freefunc TagLib::MP4::File "free_taglib_mp4_file";

%include <taglib/mp4file.h>


namespace TagLib {
  namespace MP4 {
    %template(ItemListMap) ::TagLib::Map<String, Item>;
  }
}


// Unlink Ruby objects from the deleted C++ objects. Otherwise Ruby code
// that calls a method on a tag after the file is deleted segfaults.
%begin %{
  static void free_taglib_mp4_file(void *ptr);
%}
%header %{
  static void free_taglib_mp4_file(void *ptr) {
    TagLib::MP4::File *file = (TagLib::MP4::File *) ptr;

    TagLib::MP4::Tag *tag = file->tag();
    if (tag) {
      SWIG_RubyUnlinkObjects(tag);
      SWIG_RubyRemoveTracking(tag);
    }

    TagLib::MP4::Properties *properties = file->audioProperties();
    if (properties) {
      SWIG_RubyUnlinkObjects(properties);
      SWIG_RubyRemoveTracking(properties);
    }

    SWIG_RubyUnlinkObjects(ptr);
    SWIG_RubyRemoveTracking(ptr);

    delete file;
  }
%}

%extend TagLib::MP4::File {
  void close() {
    free_taglib_mp4_file($self);
  }
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
