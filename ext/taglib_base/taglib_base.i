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

// Undefine macro
#define TAGLIB_EXPORT

namespace TagLib {
  class StringList;
}

%typemap(out) TagLib::String {
  $result = rb_str_new2($1.to8Bit(true).c_str());
}

/*
%typemap(in) FileName {
  $1 = rb_string_value_cstr(&$input);
}
%typemap(typecheck) FileName = char *;
*/

%include <taglib/taglib.h>

// ByteVector
%ignore TagLib::ByteVector::operator[];
%ignore TagLib::ByteVector::operator=;
%ignore TagLib::ByteVector::operator!=;
%ignore operator<<;
%include <taglib/tbytevector.h>
%typemap(out) TagLib::ByteVector {
  $result = rb_str_new($1.data(), $1.size());
}
%typemap(in) TagLib::ByteVector {
  $1 = new ByteVector(rb_string_value_ptr($input), NUM2UINT(rb_str_length($input)));
}

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
