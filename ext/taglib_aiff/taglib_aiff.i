%module "TagLib::RIFF::AIFF"
%{
#include <taglib/taglib.h>
#include <taglib/aifffile.h>
#include <taglib/aiffproperties.h>
#include <taglib/id3v2tag.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%include <taglib/aiffproperties.h>

%freefunc TagLib::RIFF::AIFF::File "free_taglib_riff_aiff_file";

%rename("id3v2_tag?") TagLib::RIFF::AIFF::File::hasID3v2Tag;

namespace TagLib {
  namespace ID3v2 {
    class Tag;
  }
}

%include <taglib/aifffile.h>

// Unlink Ruby objects from the deleted C++ objects. Otherwise Ruby code
// that calls a method on a tag after the file is deleted segfaults.
%begin %{
  static void free_taglib_riff_aiff_file(void *ptr);
%}
%header %{
  static void free_taglib_riff_aiff_file(void *ptr) {
    TagLib::RIFF::AIFF::File *file = (TagLib::RIFF::AIFF::File *) ptr;

    TagLib::ID3v2::Tag *id3v2tag = file->tag();
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

    TagLib::RIFF::AIFF::Properties *properties = file->audioProperties();
    if (properties) {
      SWIG_RubyUnlinkObjects(properties);
      SWIG_RubyRemoveTracking(properties);
    }

    SWIG_RubyUnlinkObjects(ptr);
    SWIG_RubyRemoveTracking(ptr);

    delete file;
  }
%}

%extend TagLib::RIFF::AIFF::File {
  void close() {
    free_taglib_riff_aiff_file($self);
  }
}


// vim: set filetype=cpp sw=2 ts=2 expandtab:
