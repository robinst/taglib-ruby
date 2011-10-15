%trackobjects;

// Undefine macro
#define TAGLIB_EXPORT

// Replaces the typemap from swigtype.swg and just adds the line
// SWIG_RubyUnlinkObjects. This is done to be safe in the case when a
// disowned object is deleted by C++ (e.g. with remove_frame).
%typemap(in, noblock=1) SWIGTYPE *DISOWN (int res = 0) {
  res = SWIG_ConvertPtr($input, %as_voidptrptr(&$1), $descriptor, SWIG_POINTER_DISOWN | %convertptr_flags);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res,"$type", $symname, $argnum);
  }
  SWIG_RubyUnlinkObjects(%as_voidptr($1));
}

%{
#include <taglib/tstring.h>
#include <taglib/tstringlist.h>
#include <taglib/tfile.h>

#if defined(HAVE_RUBY_ENCODING_H) && HAVE_RUBY_ENCODING_H
# include <ruby/encoding.h>
# define ASSOCIATE_UTF8_ENCODING(value) rb_enc_associate(value, rb_utf8_encoding());
# define CONVERT_TO_UTF8(value) rb_str_export_to_enc(value, rb_utf8_encoding())
#else
# define ASSOCIATE_UTF8_ENCODING(value) /* nothing */
# define CONVERT_TO_UTF8(value) value
#endif

VALUE taglib_bytevector_to_ruby_string(const TagLib::ByteVector &byteVector) {
  if (byteVector.isNull()) {
    return Qnil;
  } else {
    return rb_tainted_str_new(byteVector.data(), byteVector.size());
  }
}

TagLib::ByteVector ruby_string_to_taglib_bytevector(VALUE s) {
  return TagLib::ByteVector(RSTRING_PTR(s), RSTRING_LEN(s));
}

VALUE taglib_string_to_ruby_string(const TagLib::String & string) {
  if (string.isNull()) {
    return Qnil;
  } else {
    VALUE result = rb_tainted_str_new2(string.toCString(true));
    ASSOCIATE_UTF8_ENCODING(result);
    return result;
  }
}

TagLib::String ruby_string_to_taglib_string(VALUE s) {
  return TagLib::String(RSTRING_PTR(CONVERT_TO_UTF8(s)), TagLib::String::UTF8);
}

VALUE taglib_string_list_to_ruby_array(const TagLib::StringList & list) {
  VALUE ary = rb_ary_new2(list.size());
  for (TagLib::StringList::ConstIterator it = list.begin(); it != list.end(); it++) {
    VALUE s = taglib_string_to_ruby_string(*it);
    rb_ary_push(ary, s);
  }
  return ary;
}

TagLib::StringList ruby_array_to_taglib_string_list(VALUE ary) {
  TagLib::StringList result = TagLib::StringList();
  for (long i = 0; i < RARRAY_LEN(ary); i++) {
    VALUE e = RARRAY_PTR(ary)[i];
    TagLib::String s = ruby_string_to_taglib_string(e);
    result.append(s);
  }
  return result;
}

VALUE taglib_filename_to_ruby_string(TagLib::FileName filename) {
#ifdef _WIN32
  const char *s = (const char *) filename;
  return rb_tainted_str_new2(s);
#else
  return rb_tainted_str_new2(filename);
#endif
}

TagLib::FileName ruby_string_to_taglib_filename(VALUE s) {
#ifdef _WIN32
  const char *filename = StringValuePtr(s);
  return TagLib::FileName(filename);
#else
  return StringValuePtr(s);
#endif
}

%}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
