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

// Undefine macro
#define TAGLIB_EXPORT

namespace TagLib {
  class StringList;
  class ByteVector;

  class String {
    public:
    enum Type { Latin1 = 0, UTF16 = 1, UTF16BE = 2, UTF8 = 3, UTF16LE = 4 };
  };
}

/*
%typemap(in) FileName {
  $1 = rb_string_value_cstr(&$input);
}
%typemap(typecheck) FileName = char *;
*/

// Rename setters to Ruby convention (combining SWIG rename functions
// doesn't seem to be possible, thus resort to some magic)
%rename("%(command: ruby -e 'print(ARGV[0][3..-1].split(/(?=[A-Z])/).join(\"_\").downcase + \"=\")' )s",
        regexmatch$name="^set[A-Z]") "";

%include <taglib/taglib.h>

// ByteVector
%typemap(out) TagLib::ByteVector {
  $result = rb_str_new($1.data(), $1.size());
}
%typemap(in) TagLib::ByteVector & {
  $1 = new TagLib::ByteVector(RSTRING_PTR($input), RSTRING_LEN($input));
}

// String
%typemap(out) TagLib::String {
  $result = rb_tainted_str_new2($1.toCString(true));
  ASSOCIATE_UTF8_ENCODING($result);
}
%typemap(in) TagLib::String {
  $1 = new TagLib::String(RSTRING_PTR(CONVERT_TO_UTF8($input)), TagLib::String::UTF8);
}
%apply TagLib::String { TagLib::String &, const TagLib::String & };

%include <std_list.i>
%ignore TagLib::List::operator[];
%ignore TagLib::List::operator=;
%include <taglib/tlist.h>

%include <taglib/tfile.h>

%ignore TagLib::FileRef::operator=;
%ignore TagLib::FileRef::operator!=;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) TagLib::FileRef::FileTypeResolver;
%include <taglib/fileref.h>

%rename("empty?") TagLib::Tag::isEmpty;
%include <taglib/tag.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
