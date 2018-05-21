%module "TagLib::MP4"
%{
#include <taglib/taglib.h>
#include <taglib/mp4file.h>
#include <taglib/mp4properties.h>
#include <taglib/mp4tag.h>
#include <taglib/mp4atom.h>
// To resolve some symbols, like AtomDataType in Item.
using namespace TagLib::MP4;
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%{
static void unlink_taglib_mp4_item_map_iterator(const TagLib::MP4::ItemMap::ConstIterator &it) {
  const TagLib::MP4::Item *item = &(it->second);
  TagLib::MP4::CoverArtList list = item->toCoverArtList();
  for (TagLib::MP4::CoverArtList::ConstIterator it = list.begin(); it != list.end(); it++) {
    void *cover_art = (void *) &(*it);
    SWIG_RubyUnlinkObjects(cover_art);
    SWIG_RubyRemoveTracking(cover_art);
  }
  SWIG_RubyUnlinkObjects((void *)item);
  SWIG_RubyRemoveTracking((void *)item);
}

VALUE taglib_mp4_item_int_pair_to_ruby_array(const TagLib::MP4::Item::IntPair &int_pair) {
  VALUE ary = rb_ary_new3(2, INT2NUM(int_pair.first), INT2NUM(int_pair.second));
  return ary;
}

VALUE taglib_cover_art_list_to_ruby_array(const TagLib::MP4::CoverArtList & list) {
  VALUE ary = rb_ary_new2(list.size());
  for (TagLib::MP4::CoverArtList::ConstIterator it = list.begin(); it != list.end(); it++) {
    VALUE c = SWIG_NewPointerObj((void *) &(*it), SWIGTYPE_p_TagLib__MP4__CoverArt, 0);
    rb_ary_push(ary, c);
  }
  return ary;
}

TagLib::MP4::CoverArtList ruby_array_to_taglib_cover_art_list(VALUE ary) {
  TagLib::MP4::CoverArtList result = TagLib::MP4::CoverArtList();
  if (NIL_P(ary)) {
    return result;
  }
  for (long i = 0; i < RARRAY_LEN(ary); i++) {
    VALUE e = rb_ary_entry(ary, i);
    TagLib::MP4::CoverArt *c;
    SWIG_ConvertPtr(e, (void **) &c, SWIGTYPE_p_TagLib__MP4__CoverArt, 1);
    result.append(*c);
  }
  return result;
}
%}

// Ignore useless types that SWIG picks up globally.
%ignore Iterator;
%ignore ConstIterator;

%ignore TagLib::Map::operator[];
%ignore TagLib::Map::operator=;
%alias TagLib::Map::contains "include?,has_key?";
%include <taglib/tmap.h>

namespace TagLib {
  class ByteVectorList;
  namespace MP4 {
    class Item;
    class CoverArtList;
    class Properties;
  }
}

%ignore TagLib::MP4::Properties::length; // Deprecated.
%include <taglib/mp4properties.h>

%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::begin;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::end;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::insert;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::find;
// We will create a safe version of these below in an %extend
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::clear;
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::erase(Iterator);
%ignore TagLib::Map<TagLib::String, TagLib::MP4::Item>::erase(const TagLib::String &);

%ignore TagLib::MP4::Tag::itemListMap; // Deprecated.

%rename("__getitem__") TagLib::MP4::Tag::item;

// We will create a safe version of these below in an %extend
// TagLib::MP4::Tag::item does not need to be reimplemented as it return an Item by value.
%ignore TagLib::MP4::Tag::setItem;
%ignore TagLib::MP4::Tag::removeItem;

%include <taglib/mp4tag.h>

%typemap(out) TagLib::MP4::CoverArtList {
  $result = taglib_cover_art_list_to_ruby_array($1);
}
%typemap(in) TagLib::MP4::CoverArtList (TagLib::MP4::CoverArtList tmp) {
  tmp = ruby_array_to_taglib_cover_art_list($input);
  $1 = &tmp;
}
%apply TagLib::MP4::CoverArtList { TagLib::MP4::CoverArtList &, const TagLib::MP4::CoverArtList & };
%ignore TagLib::MP4::CoverArt::operator=;
%ignore TagLib::MP4::CoverArt::swap;
%include <taglib/mp4coverart.h>

%typemap(out) TagLib::MP4::Item::IntPair {
  $result = taglib_mp4_item_int_pair_to_ruby_array($1);
}
%ignore TagLib::MP4::Item::operator=;
%ignore TagLib::MP4::Item::swap;

%ignore TagLib::MP4::Item::atomDataType;
%ignore TagLib::MP4::Item::setAtomDataType;

%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) IntPair;
%include <taglib/mp4item.h>

%freefunc TagLib::MP4::File "free_taglib_mp4_file";

// Ignore IOStream and all the constructors using it.
%ignore IOStream;
%ignore TagLib::MP4::File::File(IOStream *, bool, Properties::ReadStyle);
%ignore TagLib::MP4::File::File(IOStream *, bool);
%ignore TagLib::MP4::File::File(IOStream *);

// Ignore the unified property interface.
%ignore TagLib::MP4::File::properties;
%ignore TagLib::MP4::File::setProperties;
%ignore TagLib::MP4::File::removeUnsupportedProperties;

%rename("mp4_tag?") TagLib::MP4::File::hasMP4Tag;
%include <taglib/mp4file.h>

namespace TagLib {
  namespace MP4 {
    %template(ItemMap) ::TagLib::Map<String, Item>;
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
      TagLib::MP4::ItemMap *item_list_map = const_cast<TagLib::MP4::ItemMap *>(&(tag->itemMap()));
      if (item_list_map) {
        for (TagLib::MP4::ItemMap::Iterator it = item_list_map->begin(); it != item_list_map->end(); it++) {
          unlink_taglib_mp4_item_map_iterator(it);
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
      for (TagLib::MP4::ItemMap::Iterator it = $self->begin(); it != $self->end(); it++) {
        TagLib::String string = it->first;
        TagLib::MP4::Item *item = &(it->second);
        VALUE pair = rb_ary_new2(2);
        rb_ary_push(pair, taglib_string_to_ruby_string(string));
        rb_ary_push(pair, SWIG_NewPointerObj(item, SWIGTYPE_p_TagLib__MP4__Item, 0));
        rb_ary_push(ary, pair);
      }
      return ary;
    }

    VALUE to_h() {
      VALUE hsh = rb_hash_new();
      for (TagLib::MP4::ItemMap::Iterator it = $self->begin(); it != $self->end(); it++) {
        rb_hash_aset(hsh,
                     taglib_string_to_ruby_string(it->first),
                     SWIG_NewPointerObj(&(it->second), SWIGTYPE_p_TagLib__MP4__Item, 0));
      }
      return hsh;
    }

    VALUE fetch(const String &string) {
      TagLib::MP4::ItemMap::Iterator it = $self->find(string);
      VALUE result = Qnil;
      if (it != $self->end()) {
        TagLib::MP4::Item *item = &(it->second);
        result = SWIG_NewPointerObj(item, SWIGTYPE_p_TagLib__MP4__Item, 0);
      }
      return result;
    }

    VALUE _clear() {
      for (TagLib::MP4::ItemMap::Iterator it = $self->begin(); it != $self->end(); it++) {
        unlink_taglib_mp4_item_map_iterator(it);
      }
      $self->clear();
      return Qnil;
    }

    VALUE erase(const String &string) {
      TagLib::MP4::ItemMap::Iterator it = $self->find(string);
      if (it != $self->end()) {
        unlink_taglib_mp4_item_map_iterator(it);
        $self->erase(it);
      }
      return Qnil;
    }

    VALUE _insert(const String &string, const MP4::Item &item) {
      TagLib::MP4::ItemMap::Iterator it = $self->find(string);
      if (it != $self->end()) {
        unlink_taglib_mp4_item_map_iterator(it);
      }
      $self->insert(string, item);
      return Qnil;
    }
  }
}

%extend TagLib::MP4::Tag {
  VALUE __setitem__(const String& string, const MP4::Item &item) {
    TagLib::MP4::ItemMap::ConstIterator it = $self->itemMap().find(string);
    if (it != $self->itemMap().end()) {
      unlink_taglib_mp4_item_map_iterator(it);
    }
    $self->setItem(string, item);
    return Qnil;
  }

  VALUE remove_item(const String& string) {
    TagLib::MP4::ItemMap::ConstIterator it = $self->itemMap().find(string);
    if (it != $self->itemMap().end()) {
      unlink_taglib_mp4_item_map_iterator(it);
      $self->removeItem(string);
    }
    return Qnil;
  }

}

%extend TagLib::MP4::Item {
  static TagLib::MP4::Item * from_bool(bool q) {
    return new TagLib::MP4::Item(q);
  }

  static TagLib::MP4::Item * from_byte(unsigned char n) {
    return new TagLib::MP4::Item(n);
  }

  static TagLib::MP4::Item * from_uint(unsigned int n) {
    return new TagLib::MP4::Item(n);
  }

  static TagLib::MP4::Item * from_int(int n) {
    return new TagLib::MP4::Item(n);
  }

  static TagLib::MP4::Item * from_long_long(long long n) {
    return new TagLib::MP4::Item(n);
  }

  static TagLib::MP4::Item * from_string_list(const TagLib::StringList &string_list) {
   return new TagLib::MP4::Item(string_list);
  }

  static TagLib::MP4::Item * from_cover_art_list(const TagLib::MP4::CoverArtList &cover_art_list) {
    return new TagLib::MP4::Item(cover_art_list);
  }

  static TagLib::MP4::Item * from_byte_vector_list(const TagLib::ByteVectorList &byte_vector_list) {
    return new TagLib::MP4::Item(byte_vector_list);
  }
}

%extend TagLib::MP4::File {
  void close() {
    free_taglib_mp4_file($self);
  }
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
