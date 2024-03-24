%module "TagLib"
%{
#include <taglib/taglib.h>
#include <taglib/tbytevector.h>
#include <taglib/tbytevectorlist.h>
#include <taglib/tlist.h>
#include <taglib/fileref.h>
#include <taglib/tag.h>
#include <taglib/tpropertymap.h>
#include <taglib/tvariant.h>
#include <taglib/tpicturetype.h>
using namespace TagLib;
%}

%include "includes.i"

namespace TagLib {
  class StringList;
  class ByteVector;
  class ByteVectorList;

  class String {
    public:
    enum Type { Latin1 = 0, UTF16 = 1, UTF16BE = 2, UTF8 = 3, UTF16LE = 4 };
  };

  class FileName;

  typedef wchar_t wchar;
  typedef unsigned char uchar;
  typedef unsigned int  uint;
  typedef unsigned long ulong;
}

%constant int TAGLIB_MAJOR_VERSION = TAGLIB_MAJOR_VERSION;
%constant int TAGLIB_MINOR_VERSION = TAGLIB_MINOR_VERSION;
%constant int TAGLIB_PATCH_VERSION = TAGLIB_PATCH_VERSION;

// Rename setters to Ruby convention (combining SWIG rename functions
// does not seem to be possible, thus resort to some magic)
// We used to do this with one "command" filter, but support for that was
// removed in SWIG 4.1.0. This is a bit uglier because we need one filter for
// setOne, one for setOneTwo, and one for setOneTwoThree. Looks like we don't
// need one for 4 yet.
// setFoo -> foo=
%rename("%(regex:/set([A-Z][a-z]*)([A-Z][a-z]*)([A-Z][a-z]*)/\\L\\1_\\2_\\3=/)s",
        regexmatch$name="^set([A-Z][a-z]*){3}$") "";
%rename("%(regex:/set([A-Z][a-z]*)([A-Z][a-z]*)/\\L\\1_\\2=/)s",
        regexmatch$name="^set([A-Z][a-z]*){2}$") "";
%rename("%(regex:/set([A-Z][a-z]*)/\\L\\1=/)s",
        regexmatch$name="^set([A-Z][a-z]*)$") "";

// isFoo -> foo?
%rename("%(regex:/is([A-Z][a-z]*)([A-Z][a-z]*)([A-Z][a-z]*)/\\L\\1_\\2_\\3?/)s",
        regexmatch$name="^is([A-Z][a-z]*){3}$") "";
%rename("%(regex:/is([A-Z][a-z]*)([A-Z][a-z]*)/\\L\\1_\\2?/)s",
        regexmatch$name="^is([A-Z][a-z]*){2}$") "";
%rename("%(regex:/is([A-Z][a-z]*)/\\L\\1?/)s",
        regexmatch$name="^is([A-Z][a-z]*)$") "";

// ByteVector
%typemap(out) TagLib::ByteVector {
  $result = taglib_bytevector_to_ruby_string($1);
}
%typemap(out) TagLib::ByteVector * {
  $result = taglib_bytevector_to_ruby_string(*($1));
}
%typemap(in) TagLib::ByteVector & (TagLib::ByteVector tmp) {
  tmp = ruby_string_to_taglib_bytevector($input);
  $1 = &tmp;
}
%typemap(in) TagLib::ByteVector * (TagLib::ByteVector tmp) {
  tmp = ruby_string_to_taglib_bytevector($input);
  $1 = &tmp;
}
%typemap(typecheck) const TagLib::ByteVector & = char *;

// ByteVectorList
%typemap(out) TagLib::ByteVectorList {
  $result = taglib_bytevectorlist_to_ruby_array($1);
}
%typemap(out) TagLib::ByteVectorList * {
  $result = taglib_bytevectorlist_to_ruby_array(*($1));
}
%typemap(in) TagLib::ByteVectorList & (TagLib::ByteVectorList tmp) {
  tmp = ruby_array_to_taglib_bytevectorlist($input);
  $1 = &tmp;
}
%typemap(in) TagLib::ByteVectorList * (TagLib::ByteVectorList tmp) {
  tmp = ruby_array_to_taglib_bytevectorlist($input);
  $1 = &tmp;
}

// String
%typemap(out) TagLib::String {
  $result = taglib_string_to_ruby_string($1);
}
// tmp is used for having a local variable that is destroyed at the end
// of the function. Doing "new TagLib::String" would be a big no-no.
%typemap(in) TagLib::String (TagLib::String tmp) {
  tmp = ruby_string_to_taglib_string($input);
  $1 = &tmp;
}
%typemap(typecheck) TagLib::String = char *;
%apply TagLib::String { TagLib::String &, const TagLib::String & };

// StringList
%typemap(out) TagLib::StringList {
  $result = taglib_string_list_to_ruby_array($1);
}
%typemap(in) TagLib::StringList (TagLib::StringList tmp) {
  tmp = ruby_array_to_taglib_string_list($input);
  $1 = &tmp;
}
%typemap(typecheck, precedence=SWIG_TYPECHECK_LIST) TagLib::StringList {
  $1 = TYPE($input) == T_ARRAY ? 1 : 0;
}
%apply TagLib::StringList { TagLib::StringList &, const TagLib::StringList & };

%typemap(out) TagLib::FileName {
  $result = taglib_filename_to_ruby_string($1);
}
%typemap(in) TagLib::FileName {
  $1 = ruby_string_to_taglib_filename($input);
  if ((const char *)(TagLib::FileName)($1) == NULL) {
    SWIG_exception_fail(SWIG_MemoryError, "Failed to allocate memory for file name.");
  }
}
%typemap(typecheck) TagLib::FileName = char *;
%feature("valuewrapper") TagLib::FileName;

%ignore TagLib::List::operator[];
%ignore TagLib::List::operator=;
%ignore TagLib::List::operator!=;
%include <taglib/tlist.h>

// Ignore the unified property interface.
%ignore TagLib::Tag::properties;
%ignore TagLib::Tag::setProperties;
%ignore TagLib::Tag::removeUnsupportedProperties;

%ignore TagLib::Tag::complexProperties;
%ignore TagLib::Tag::setComplexProperties;
%ignore TagLib::Tag::complexPropertyKeys;

%include <taglib/tag.h>

%ignore TagLib::AudioProperties::length; // Deprecated.
%include <taglib/audioproperties.h>

%ignore TagLib::FileName;

// Ignore the unified property interface.
%ignore TagLib::File::properties;
%ignore TagLib::File::setProperties;
%ignore TagLib::File::removeUnsupportedProperties;

%include <taglib/tfile.h>

// Ignore IOStream and all the constructors using it.
%ignore IOStream;
%ignore TagLib::FileRef::FileRef(IOStream*, bool, AudioProperties::ReadStyle);
%ignore TagLib::FileRef::FileRef(IOStream*, bool);
%ignore TagLib::FileRef::FileRef(IOStream*);

%ignore TagLib::FileRef::swap; // Only useful internally.

%ignore TagLib::FileRef::operator=;
%ignore TagLib::FileRef::operator!=;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) TagLib::FileRef::FileTypeResolver;
%include <taglib/fileref.h>

%begin %{
  static void free_taglib_fileref(void *ptr);
%}
%header %{
  static void free_taglib_fileref(void *ptr) {
    TagLib::FileRef *fileref = (TagLib::FileRef *) ptr;

    TagLib::Tag *tag = fileref->tag();
    if (tag) {
      SWIG_RubyUnlinkObjects(tag);
      SWIG_RubyRemoveTracking(tag);
    }

    TagLib::AudioProperties *properties = fileref->audioProperties();
    if (properties) {
      SWIG_RubyUnlinkObjects(properties);
      SWIG_RubyRemoveTracking(properties);
    }

    SWIG_RubyUnlinkObjects(ptr);
    SWIG_RubyRemoveTracking(ptr);

    delete fileref;
  }
%}

%extend TagLib::FileRef {
  void close() {
    free_taglib_fileref($self);
  }
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
