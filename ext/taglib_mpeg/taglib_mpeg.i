%module "TagLib::MPEG"
%{
#include <taglib/taglib.h>
#include <taglib/xingheader.h>
#include <taglib/mpegheader.h>
#include <taglib/mpegproperties.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>

static bool taglib_ruby_mpeg_file_save(TagLib::MPEG::File *file, int tags, bool stripOthers, int id3v2Version);
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%ignore TagLib::MPEG::Header::operator=;
%include <taglib/xingheader.h>
%include <taglib/mpegheader.h>
%include <taglib/mpegproperties.h>

%rename(id3v1_tag) TagLib::MPEG::File::ID3v1Tag;
%rename(id3v2_tag) TagLib::MPEG::File::ID3v2Tag;
%rename(set_id3v2_frame_factory) TagLib::MPEG::File::setID3v2FrameFactory;

%freefunc TagLib::MPEG::File "free_taglib_mpeg_file";

%include <taglib/mpegfile.h>

// Unlink Ruby objects from the deleted C++ objects. Otherwise Ruby code
// that calls a method on a tag after the file is deleted segfaults.
%begin %{
  static void free_taglib_mpeg_file(void *ptr);
%}
%header %{
  static void free_taglib_mpeg_file(void *ptr) {
    TagLib::MPEG::File *file = (TagLib::MPEG::File *) ptr;

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

    TagLib::MPEG::Properties *properties = file->audioProperties();
    if (properties) {
      SWIG_RubyUnlinkObjects(properties);
      SWIG_RubyRemoveTracking(properties);
    }

    SWIG_RubyUnlinkObjects(ptr);
    SWIG_RubyRemoveTracking(ptr);

    delete file;
  }

  static bool taglib_ruby_mpeg_file_save(TagLib::MPEG::File *file, int tags, bool stripOthers, int id3v2Version) {
#if defined(TAGLIB_MAJOR_VERSION) && (TAGLIB_MAJOR_VERSION > 1 || (TAGLIB_MAJOR_VERSION == 1 && TAGLIB_MINOR_VERSION >= 8))
    return file->save(tags, stripOthers, id3v2Version);
#else
    rb_raise(rb_eArgError, "Overloaded method save(int tags, bool stripOthers, int id3v2Version) on TagLib::MPEG::File is only available when compiled against TagLib >= 1.8");
    return false;
#endif
  }
%}

%extend TagLib::MPEG::File {
  void close() {
    free_taglib_mpeg_file($self);
  }

  bool save(int tags, bool stripOthers, int id3v2Version) {
    return taglib_ruby_mpeg_file_save($self, tags, stripOthers, id3v2Version);
  }
}


// vim: set filetype=cpp sw=2 ts=2 expandtab:
