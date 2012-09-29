%module "TagLib::FLAC"
%{
#include <taglib/taglib.h>
#include <taglib/flacfile.h>
#include <taglib/flacproperties.h>
#include <taglib/flacpicture.h>
#include <taglib/id3v1tag.h>
#include <taglib/id3v2tag.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%{
VALUE taglib_flac_picturelist_to_ruby_array(const TagLib::List<TagLib::FLAC::Picture *> & list) {
  VALUE ary = rb_ary_new2(list.size());
  for (TagLib::List<TagLib::FLAC::Picture *>::ConstIterator it = list.begin(); it != list.end(); it++) {
    TagLib::FLAC::Picture *picture = *it;
    VALUE p = SWIG_NewPointerObj(picture, SWIGTYPE_p_TagLib__FLAC__Picture, 0);
    rb_ary_push(ary, p);
  }
  return ary;
}
%}

%include <taglib/flacproperties.h>

%include <taglib/flacmetadatablock.h>
%include <taglib/flacpicture.h>

%rename(id3v1_tag) TagLib::FLAC::File::ID3v1Tag;
%rename(id3v2_tag) TagLib::FLAC::File::ID3v2Tag;
%rename(set_id3v2_frame_factory) TagLib::FLAC::File::setID3v2FrameFactory;

%typemap(out) TagLib::List<TagLib::FLAC::Picture *> {
  $result = taglib_flac_picturelist_to_ruby_array($1);
}

%freefunc TagLib::FLAC::File "free_taglib_flac_file";

%apply SWIGTYPE *DISOWN { TagLib::FLAC::Picture *picture };
// Don't expose second parameter, memory should be freed by TagLib
%ignore TagLib::FLAC::File::removePicture(Picture *, bool);

%include <taglib/flacfile.h>

// Unlink Ruby objects from the deleted C++ objects. Otherwise Ruby code
// that calls a method on a tag after the file is deleted segfaults.
%begin %{
  static void free_taglib_flac_file(void *ptr);
%}
%header %{
  static void free_taglib_flac_file(void *ptr) {
    TagLib::FLAC::File *file = (TagLib::FLAC::File *) ptr;

    TagLib::Tag *tag = file->tag();
    if (tag) {
      SWIG_RubyUnlinkObjects(tag);
      SWIG_RubyRemoveTracking(tag);
    }

    TagLib::ID3v1::Tag *id3v1tag = file->ID3v1Tag(false);
    if (id3v1tag) {
      SWIG_RubyUnlinkObjects(id3v1tag);
      SWIG_RubyRemoveTracking(id3v1tag);
    }

    TagLib::ID3v2::Tag *id3v2tag = file->ID3v2Tag(false);
    if (id3v2tag) {
      TagLib::ID3v2::FrameList frames = id3v2tag->frameList();
      for (TagLib::ID3v2::FrameList::ConstIterator it = frames.begin(); it != frames.end(); it++) {
        TagLib::ID3v2::Frame *frame = (*it);
        SWIG_RubyUnlinkObjects(frame);
        SWIG_RubyRemoveTracking(frame);
      }

      SWIG_RubyUnlinkObjects(id3v2tag);
      SWIG_RubyRemoveTracking(id3v2tag);
    }

    TagLib::Ogg::XiphComment *xiphComment = file->xiphComment(false);
    if (xiphComment) {
      SWIG_RubyUnlinkObjects(xiphComment);
      SWIG_RubyRemoveTracking(xiphComment);
    }

    TagLib::FLAC::Properties *properties = file->audioProperties();
    if (properties) {
      SWIG_RubyUnlinkObjects(properties);
      SWIG_RubyRemoveTracking(properties);
    }

    SWIG_RubyUnlinkObjects(ptr);
    SWIG_RubyRemoveTracking(ptr);

    delete file;
  }
%}

%extend TagLib::FLAC::File {
  void close() {
    free_taglib_flac_file($self);
  }
}


// vim: set filetype=cpp sw=2 ts=2 expandtab:
