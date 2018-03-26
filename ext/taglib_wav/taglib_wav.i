%module "TagLib::RIFF::WAV"
%{
#include <taglib/taglib.h>
#include <taglib/wavfile.h>
#include <taglib/wavproperties.h>
#include <taglib/id3v2tag.h>
using namespace TagLib::RIFF;
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

// Deprecated
%ignore TagLib::RIFF::WAV::Properties::Properties(const ByteVector&, ReadStyle);
%ignore TagLib::RIFF::WAV::Properties::Properties(const ByteVector&, unsigned int, ReadStyle);
%ignore TagLib::RIFF::WAV::Properties::length;
%ignore TagLib::RIFF::WAV::Properties::sampleWidth;

%include <taglib/wavproperties.h>

%freefunc TagLib::RIFF::WAV::File "free_taglib_riff_wav_file";

namespace TagLib {
  namespace ID3v2 {
    class Tag;
  }
}

// Ignore IOStream and all the constructors using it.
%ignore IOStream;
%ignore TagLib::RIFF::WAV::File::File(IOStream *, bool, Properties::ReadStyle);
%ignore TagLib::RIFF::WAV::File::File(IOStream *, bool);
%ignore TagLib::RIFF::WAV::File::File(IOStream *);

// Ignore the unified property interface.
%ignore TagLib::RIFF::WAV::File::properties;
%ignore TagLib::RIFF::WAV::File::setProperties;
%ignore TagLib::RIFF::WAV::File::removeUnsupportedProperties;

%ignore TagLib::RIFF::WAV::File::InfoTag;

%rename(id3v2_tag) TagLib::RIFF::WAV::File::ID3v2Tag;
%rename("id3v2_tag?") TagLib::RIFF::WAV::File::hasID3v2Tag;
%rename("info_tag?") TagLib::RIFF::WAV::File::hasInfoTag;

%include <taglib/wavfile.h>

// Unlink Ruby objects from the deleted C++ objects. Otherwise Ruby code
// that calls a method on a tag after the file is deleted segfaults.
%begin %{
  static void free_taglib_riff_wav_file(void *ptr);
%}
%header %{
  static void free_taglib_riff_wav_file(void *ptr) {
    TagLib::RIFF::WAV::File *file = (TagLib::RIFF::WAV::File *) ptr;

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

    TagLib::RIFF::WAV::Properties *properties = file->audioProperties();
    if (properties) {
      SWIG_RubyUnlinkObjects(properties);
      SWIG_RubyRemoveTracking(properties);
    }

    SWIG_RubyUnlinkObjects(ptr);
    SWIG_RubyRemoveTracking(ptr);

    delete file;
  }
%}

%extend TagLib::RIFF::WAV::File {
  void close() {
    free_taglib_riff_wav_file($self);
  }
}


// vim: set filetype=cpp sw=2 ts=2 expandtab:
