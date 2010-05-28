%module TagLib
%{
#include <taglib/taglib.h>
#include <taglib/tstring.h>
#include <taglib/tfile.h>
#include <taglib/fileref.h>
#include <taglib/tag.h>

using namespace TagLib;
%}

// Undefine macro
#define TAGLIB_EXPORT

%typemap(out) TagLib::String {
  $result = rb_str_new2($1.to8Bit(true).c_str());
}

%typemap(in) FileName {
  $1 = rb_string_value_cstr(&$input);
}
%typemap(typecheck) FileName = char *;

%include <taglib/taglib.h>
%include <taglib/fileref.h>
%include <taglib/tag.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
