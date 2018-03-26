%module "TagLib::Ogg::Vorbis"
%{
#include <taglib/taglib.h>
#include <taglib/vorbisproperties.h>
#include <taglib/vorbisfile.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_ogg") "../taglib_ogg/taglib_ogg.i"

%freefunc TagLib::Vorbis::File "free_taglib_vorbis_file";

// Ignore IOStream and all the constructors using it.
%ignore IOStream;
%ignore TagLib::Vorbis::File::File(IOStream *, bool, Properties::ReadStyle);
%ignore TagLib::Vorbis::File::File(IOStream *, bool);
%ignore TagLib::Vorbis::File::File(IOStream *);

%ignore TagLib::Vorbis::Properties::length; // Deprecated.
%include <taglib/vorbisproperties.h>

%include <taglib/vorbisfile.h>

%begin %{
  static void free_taglib_vorbis_file(void *ptr);
%}
%header %{
  static void free_taglib_vorbis_file(void *ptr) {
    TagLib::Ogg::Vorbis::File *file = (TagLib::Ogg::Vorbis::File *) ptr;

    TagLib::Ogg::XiphComment *tag = file->tag();
    if (tag) {
      SWIG_RubyUnlinkObjects(tag);
      SWIG_RubyRemoveTracking(tag);
    }

    TagLib::Vorbis::Properties *properties = file->audioProperties();
    if (properties) {
      SWIG_RubyUnlinkObjects(properties);
      SWIG_RubyRemoveTracking(properties);
    }

    SWIG_RubyUnlinkObjects(file);
    SWIG_RubyRemoveTracking(file);

    delete file;
  }
%}

%extend TagLib::Vorbis::File {
  void close() {
    free_taglib_vorbis_file($self);
  }
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
