%module "TagLib::Ogg"
%{
#include <taglib/taglib.h>
#include <taglib/oggfile.h>
#include <taglib/xiphcomment.h>

static VALUE taglib_ruby_ogg_xiphcomment_fieldlistmap(TagLib::Ogg::XiphComment *tag);
static void taglib_ruby_ogg_xiphcomment_add_field(TagLib::Ogg::XiphComment *tag, const TagLib::String &key, const TagLib::String &value, bool replace);
static void taglib_ruby_ogg_xiphcomment_remove_field(TagLib::Ogg::XiphComment *tag, const TagLib::String &key, const TagLib::String &value);
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%typemap(out) TagLib::Ogg::FieldListMap {
  $result = taglib_ogg_fieldlistmap_to_ruby_hash(*$1);
}
%apply TagLib::Ogg::FieldListMap { const TagLib::Ogg::FieldListMap & };

%include <taglib/oggfile.h>

%rename("contains?") TagLib::Ogg::XiphComment::contains;

// Starting with taglib-1.11, pictures are not accessible as fields,
// but through a list of FLAC::Picture. For backward compatibility,
// the following methods are overloaded in %extend in order to
// continue to handle pictures as standard fields.
%ignore TagLib::Ogg::XiphComment::fieldListMap;
%ignore TagLib::Ogg::XiphComment::addField;
%ignore TagLib::Ogg::XiphComment::removeField;

%include <taglib/xiphcomment.h>

%{
  VALUE taglib_ogg_fieldlistmap_to_ruby_hash(const TagLib::Ogg::FieldListMap & map) {
    VALUE hash = rb_hash_new();
    for (TagLib::Ogg::FieldListMap::ConstIterator it = map.begin(); it != map.end(); it++) {
      TagLib::String key = (*it).first;
      TagLib::StringList value = (*it).second;
      VALUE k = taglib_string_to_ruby_string(key);
      VALUE v = taglib_string_list_to_ruby_array(value);
      rb_hash_aset(hash, k, v);
    }
    return hash;
  }

  static VALUE taglib_ruby_ogg_xiphcomment_fieldlistmap(TagLib::Ogg::XiphComment *tag)
  {
    VALUE hash = taglib_ogg_fieldlistmap_to_ruby_hash(tag->fieldListMap());

#if defined(TAGLIB_MAJOR_VERSION) && (TAGLIB_MAJOR_VERSION > 1 || (TAGLIB_MAJOR_VERSION == 1 && TAGLIB_MINOR_VERSION >= 11))
    // Inject pictures to the fields map.
    const TagLib::List<TagLib::FLAC::Picture *> pictures = tag->pictureList();
    if (pictures.size() > 0) {
      VALUE ary = rb_ary_new2(pictures.size());

      for (TagLib::List<TagLib::FLAC::Picture *>::ConstIterator it = pictures.begin(); it != pictures.end(); ++it) {
        rb_ary_push(ary, taglib_bytevector_to_ruby_string((*it)->render().toBase64()));
      }

      rb_hash_aset(hash, rb_tainted_str_new2("METADATA_BLOCK_PICTURE"), ary);
    }
#endif

    return hash;
  }

#if defined(TAGLIB_MAJOR_VERSION) && (TAGLIB_MAJOR_VERSION > 1 || (TAGLIB_MAJOR_VERSION == 1 && TAGLIB_MINOR_VERSION >= 11))
  // Build a FLAC::Picture from the content of a COVERART field (Base64-encoded image).
  static TagLib::FLAC::Picture *buildPictureFromBase64CoverArt(TagLib::FLAC::Picture *picture, const TagLib::String &value) {
    picture->setData(TagLib::ByteVector::fromBase64(value.data(TagLib::String::Latin1)));
    picture->setMimeType("image/");
    picture->setType(TagLib::FLAC::Picture::Other);
    return picture;
  }

  enum { NOTAPICTURE, METADATA_BLOCK_PICTURE, COVERART };

  static int picture_type(const TagLib::String &key) {
    const TagLib::String ukey = key.upper();
    if (ukey == "METADATA_BLOCK_PICTURE")
      return METADATA_BLOCK_PICTURE;
    if (ukey == "COVERART")
      return COVERART;

    return NOTAPICTURE;
  }
#endif

  static void taglib_ruby_ogg_xiphcomment_add_field(TagLib::Ogg::XiphComment *tag, const TagLib::String &key, const TagLib::String &value, bool replace)
  {
#if defined(TAGLIB_MAJOR_VERSION) && (TAGLIB_MAJOR_VERSION > 1 || (TAGLIB_MAJOR_VERSION == 1 && TAGLIB_MINOR_VERSION >= 11))
    const int tag_type = picture_type(key);

    if (tag_type == NOTAPICTURE) {
      tag->addField(key, value, replace);
      return;
    }

    if (replace)
      tag->removeAllPictures();

    TagLib::FLAC::Picture *picture = new TagLib::FLAC::Picture();

    if (tag_type == METADATA_BLOCK_PICTURE) {
      // value is expected to be a valid METADATA_BLOCK_PICTURE, Base64-encoded, as specified here:
      // https://xiph.org/flac/format.html#metadata_block_picture
      if(picture->parse(TagLib::ByteVector::fromBase64(value.data(TagLib::String::Latin1)))) {
        tag->addPicture(picture); // Ownership of the picture has been transferred.
      } else {
        delete picture; // Not a valid METADATA_BLOCK_PICTURE, nothing we can do.
      }
    } else { // COVERART
      tag->addPicture(buildPictureFromBase64CoverArt(picture, value)); // Ownership of the picture has been transferred.
    }
#else
    tag->addField(key, value, replace);
#endif
  }

  static void taglib_ruby_ogg_xiphcomment_remove_field(TagLib::Ogg::XiphComment *tag, const TagLib::String &key, const TagLib::String &value)
  {
#if defined(TAGLIB_MAJOR_VERSION) && (TAGLIB_MAJOR_VERSION > 1 || (TAGLIB_MAJOR_VERSION == 1 && TAGLIB_MINOR_VERSION >= 11))
    const int tag_type = picture_type(key);

    if (key != "METADATA_BLOCK_PICTURE") {
      tag->removeField(key, value);
      return;
    }

    if (value.isNull()) {
      tag->removeAllPictures();
      return;
    }

    const TagLib::ByteVector pictureData = TagLib::ByteVector::fromBase64(value.data(TagLib::String::Latin1));

    TagLib::List<TagLib::FLAC::Picture *> picturesToRemove;

    {
      // This list needs to be scoped, otherwise, when being destroyed, it will try
      // to delete pictures that have already been destroyed by removePicture().
      const TagLib::List<TagLib::FLAC::Picture *> pictures = tag->pictureList();
      for (TagLib::List<TagLib::FLAC::Picture *>::ConstIterator it = pictures.begin(); it != pictures.end(); ++it) {
        if ((*it)->render() == pictureData) {
          picturesToRemove.append(*it);
        }
      }
    }

    for (TagLib::List<TagLib::FLAC::Picture *>::ConstIterator it = picturesToRemove.begin(); it != picturesToRemove.end(); ++it) {
      tag->removePicture(*it);
    }
#else
    tag->removeField(key, value);
#endif
  }
%}

%extend TagLib::Ogg::XiphComment {
  VALUE field_list_map() {
    return taglib_ruby_ogg_xiphcomment_fieldlistmap($self);
  }

  void add_field(const TagLib::String &key, const TagLib::String &value, bool replace = true) {
    taglib_ruby_ogg_xiphcomment_add_field($self, key, value, replace);
  }

  void remove_field(const TagLib::String &key, const TagLib::String &value = TagLib::String::null) {
    taglib_ruby_ogg_xiphcomment_remove_field($self, key, value);
  }
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
