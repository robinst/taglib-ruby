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
%alias TagLib::Map::contains "include?,has_key?";
%include <taglib/tmap.h>

%include <taglib/tiostream.h>
%include <taglib/tbytevectorlist.h>

namespace TagLib {
  namespace MP4 {
    class Item;
    class CoverArtList;
    class Properties;
  }
}

%include <taglib/mp4properties.h>

%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::begin;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::end;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::insert;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::clear;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::find;
// We will create a safe version of #erase below in an %extend
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::erase(Iterator);
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::erase(const TagLib::String &);
%include <taglib/mp4tag.h>

%include <taglib/mp4atom.h>
%include <taglib/mp4item.h>

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
      TagLib::Map<TagLib::String, TagLib::MP4::Item> *item_list_map = &(tag->itemListMap());
      if(item_list_map) {
        for (TagLib::MP4::ItemListMap::Iterator it = item_list_map->begin(); it != item_list_map->end(); it++) {
          TagLib::MP4::Item *item = &(it->second);
          SWIG_RubyUnlinkObjects(item);
          SWIG_RubyRemoveTracking(item);
        }

        SWIG_RubyUnlinkObjects(item_list_map);
        SWIG_RubyRemoveTracking(item_list_map);
      }

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

namespace TagLib {
  %extend Map<String, MP4::Item> {
    VALUE fetch(VALUE string) {
      TagLib::MP4::ItemListMap::Iterator it = $self->find(ruby_string_to_taglib_string(string));
      VALUE result = Qnil;
      if (it != $self->end()) {
        TagLib::MP4::Item *item = &(it->second);
        result = SWIG_NewPointerObj(item, SWIGTYPE_p_TagLib__MP4__Item, 0);
      }
      return result;
    }

    VALUE erase(VALUE string) {
      TagLib::MP4::ItemListMap::Iterator it = $self->find(ruby_string_to_taglib_string(string));
      if (it != $self->end()) {
        TagLib::MP4::Item *item = &(it->second);
        SWIG_RubyUnlinkObjects(item);
        SWIG_RubyRemoveTracking(item);
        $self->erase(it);
      }
      return Qnil;
    }
  }
}

%extend TagLib::MP4::File {
  void close() {
    free_taglib_mp4_file($self);
  }
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
