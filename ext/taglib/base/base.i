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

#pragma SWIG nowarn=SWIGWARN_PARSE_NESTED_CLASS

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

%include <taglib/tbytevector.h>

%include <std_list.i>
%include <taglib/tlist.h>

%include <taglib/tfile.h>

%ignore TagLib::FileRef::operator=;
%ignore TagLib::FileRef::operator!=;
%include <taglib/fileref.h>

%include <taglib/tag.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
