%module "TagLib::MP4"
%{
#include <taglib/taglib.h>
#include <taglib/mp4file.h>
#include <taglib/mp4properties.h>
#include <taglib/mp4tag.h>

static void unlink_taglib_mp4_item_list_map_iterator(TagLib::MP4::ItemListMap::Iterator &it) {
  TagLib::MP4::Item *item = &(it->second);
  SWIG_RubyUnlinkObjects(item);
  SWIG_RubyRemoveTracking(item);
}
%}

%ignore TagLib::List::operator!=;
%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%ignore TagLib::Map::operator[];
%ignore TagLib::Map::operator=;
%alias TagLib::Map::contains "include?,has_key?";
%include <taglib/tmap.h>

%import <taglib/tiostream.h>

namespace TagLib {
  %template() List<ByteVector>;

  namespace MP4 {
    class Item;
    class CoverArtList;
    class Properties;

    struct IntPair {
      int first, second;
    };
  }
}

%include <taglib/tbytevectorlist.h>

%include <taglib/mp4properties.h>

%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::begin;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::end;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::insert;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::find;
// We will create a safe version of these below in an %extend
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::clear;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::erase(Iterator);
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::erase(const TagLib::String &);
%include <taglib/mp4tag.h>

%import <taglib/mp4atom.h>

%nestedworkaround TagLib::MP4::Item::IntPair;
%{
  namespace TagLib {
    namespace MP4 {
      typedef Item::IntPair IntPair;
    }
  }
%}
%ignore TagLib::MP4::Item::operator=;
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
          unlink_taglib_mp4_item_list_map_iterator(it);
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
    VALUE to_a() {
      VALUE ary = rb_ary_new2($self->size());
      for (TagLib::MP4::ItemListMap::Iterator it = $self->begin(); it != $self->end(); it++) {
        TagLib::String string = it->first;
        TagLib::MP4::Item *item = &(it->second);
        VALUE pair = rb_ary_new2(2);
        rb_ary_push(pair, taglib_string_to_ruby_string(string));
        rb_ary_push(pair, SWIG_NewPointerObj(item, SWIGTYPE_p_TagLib__MP4__Item, 0));
        rb_ary_push(ary, pair);
      }
      return ary;
    }

    VALUE fetch(const String &string) {
      TagLib::MP4::ItemListMap::Iterator it = $self->find(string);
      VALUE result = Qnil;
      if (it != $self->end()) {
        TagLib::MP4::Item *item = &(it->second);
        result = SWIG_NewPointerObj(item, SWIGTYPE_p_TagLib__MP4__Item, 0);
      }
      return result;
    }

    VALUE _clear() {
      for (TagLib::MP4::ItemListMap::Iterator it = $self->begin(); it != $self->end(); it++) {
        unlink_taglib_mp4_item_list_map_iterator(it);
      }
      $self->clear();
      return Qnil;
    }

    VALUE erase(const String &string) {
      TagLib::MP4::ItemListMap::Iterator it = $self->find(string);
      if (it != $self->end()) {
        unlink_taglib_mp4_item_list_map_iterator(it);
        $self->erase(it);
      }
      return Qnil;
    }

    VALUE _insert(const String &string, const MP4::Item &item) {
      TagLib::MP4::ItemListMap::Iterator it = $self->find(string);
      if (it != $self->end()) {
        unlink_taglib_mp4_item_list_map_iterator(it);
      }
      $self->insert(string, item);
      return Qnil;
    }
  }
}

%extend TagLib::MP4::Item {
  static TagLib::MP4::Item * from_int(int n) {
    return new TagLib::MP4::Item(n);
  }

  static TagLib::MP4::Item * from_byte(uchar c) {
    return new TagLib::MP4::Item(c);
  }

  static TagLib::MP4::Item * from_uint(uint n) {
    return new TagLib::MP4::Item(n);
  }

  static TagLib::MP4::Item * from_long_long(long long n) {
    return new TagLib::MP4::Item(n);
  }

  static TagLib::MP4::Item * from_bool(bool q) {
    return new TagLib::MP4::Item(q);
  }

  static TagLib::MP4::Item * from_string_list(const TagLib::StringList &string_list) {
   return new TagLib::MP4::Item(string_list);
  }
}

%extend TagLib::MP4::File {
  void close() {
    free_taglib_mp4_file($self);
  }
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
