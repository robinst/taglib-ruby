%module "TagLib::MPEG"
%{
#include <taglib/taglib.h>
#include <taglib/tfile.h>
#include <taglib/mpegproperties.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>
%}

%include <std_list.i>

%import(module="taglib_base") "../taglib_base/taglib_base.i"

namespace TagLib {
  namespace MPEG {
    class Properties;
  }
}

%rename(id3v1_tag) TagLib::MPEG::File::ID3v1Tag;
%rename(id3v2_tag) TagLib::MPEG::File::ID3v2Tag;
%rename(set_id3v2_frame_factory) TagLib::MPEG::File::setID3v2FrameFactory;

%freefunc TagLib::MPEG::File "free_taglib_mpeg_file";

%include <taglib/mpegfile.h>

// Unlink Ruby objects from the deleted C++ objects. Otherwise Ruby code
// that calls a method on a tag after the file is deleted segfaults.
%header %{
  static void free_taglib_mpeg_file(void *ptr) {
    TagLib::MPEG::File *file = (TagLib::MPEG::File *) ptr;

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

    SWIG_RubyRemoveTracking(ptr);

    delete file;
  }
%}


// vim: set filetype=cpp sw=2 ts=2 expandtab:
