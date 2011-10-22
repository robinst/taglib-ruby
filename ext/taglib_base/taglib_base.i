%module "TagLib"
%{
#include <taglib/taglib.h>
#include <taglib/tstring.h>
#include <taglib/tbytevector.h>
#include <taglib/tlist.h>
#include <taglib/tfile.h>
#include <taglib/fileref.h>
#include <taglib/tag.h>
%}

%include "includes.i"

namespace TagLib {
  class StringList;
  class ByteVector;

  class String {
    public:
    enum Type { Latin1 = 0, UTF16 = 1, UTF16BE = 2, UTF8 = 3, UTF16LE = 4 };
  };

  typedef unsigned int uint;
}


// Rename setters to Ruby convention (combining SWIG rename functions
// doesn't seem to be possible, thus resort to some magic)
%rename("%(command: ruby -e 'print(ARGV[0][3..-1].split(/(?=[A-Z])/).join(\"_\").downcase + \"=\")' )s",
        regexmatch$name="^set[A-Z]") "";

// isFoo -> foo?
%rename("%(command: ruby -e 'print(ARGV[0][2..-1].split(/(?=[A-Z])/).join(\"_\").downcase + \"?\")' )s",
        regexmatch$name="^is[A-Z]") "";

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
%apply TagLib::String { TagLib::String &, const TagLib::String & };

// StringList
%typemap(out) TagLib::StringList {
  $result = taglib_string_list_to_ruby_array($1);
}
%typemap(in) TagLib::StringList (TagLib::StringList tmp) {
  tmp = ruby_array_to_taglib_string_list($input);
  $1 = &tmp;
}
%apply TagLib::StringList { TagLib::StringList &, const TagLib::StringList & };

%ignore TagLib::List::operator[];
%ignore TagLib::List::operator=;
%include <taglib/tlist.h>

%include <taglib/tag.h>

%include <taglib/audioproperties.h>

%include <taglib/tfile.h>

%ignore TagLib::FileRef::operator=;
%ignore TagLib::FileRef::operator!=;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) TagLib::FileRef::FileTypeResolver;
%include <taglib/fileref.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
