%trackobjects;

// Undefine macros we don't need for wrapping
#define TAGLIB_EXPORT
#define TAGLIB_IGNORE_MISSING_DESTRUCTOR

// Replaces the typemap from swigtype.swg and just adds the line
// SWIG_RubyUnlinkObjects. This is done to be safe in the case when a
// disowned object is deleted by C++ (e.g. with remove_frame).
%typemap(in, noblock=1) SWIGTYPE *DISOWN (int res = 0) {
  res = SWIG_ConvertPtr($input, %as_voidptrptr(&$1), $descriptor, SWIG_POINTER_DISOWN | %convertptr_flags);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res,"$type", $symname, $argnum);
  }
  SWIG_RubyUnlinkObjects($1);
  SWIG_RubyRemoveTracking($1);
}

%{
#include <taglib/tstring.h>
#include <taglib/tstringlist.h>
#include <taglib/tfile.h>

#if defined(HAVE_RUBY_ENCODING_H) && HAVE_RUBY_ENCODING_H
# include <ruby/encoding.h>
# define ASSOCIATE_UTF8_ENCODING(value) rb_enc_associate(value, rb_utf8_encoding());
# define ASSOCIATE_FILESYSTEM_ENCODING(value) rb_enc_associate(value, rb_filesystem_encoding());
# define CONVERT_TO_UTF8(value) rb_str_export_to_enc(value, rb_utf8_encoding())
#else
# define ASSOCIATE_UTF8_ENCODING(value) /* nothing */
# define ASSOCIATE_FILESYSTEM_ENCODING(value)
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
  if (NIL_P(s)) {
    return TagLib::ByteVector::null;
  } else {
    return TagLib::ByteVector(RSTRING_PTR(StringValue(s)), RSTRING_LEN(s));
  }
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
  if (NIL_P(s)) {
    return TagLib::String::null;
  } else {
    return TagLib::String(RSTRING_PTR(CONVERT_TO_UTF8(StringValue(s))), TagLib::String::UTF8);
  }
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
  if (NIL_P(ary)) {
    return result;
  }
  for (long i = 0; i < RARRAY_LEN(ary); i++) {
    VALUE e = RARRAY_PTR(ary)[i];
    TagLib::String s = ruby_string_to_taglib_string(e);
    result.append(s);
  }
  return result;
}

VALUE taglib_filename_to_ruby_string(TagLib::FileName filename) {
  VALUE result;
#ifdef _WIN32
  const char *s = (const char *) filename;
  result = rb_tainted_str_new2(s);
#else
  result = rb_tainted_str_new2(filename);
#endif
  ASSOCIATE_FILESYSTEM_ENCODING(result);
  return result;
}

TagLib::FileName ruby_string_to_taglib_filename(VALUE s) {
#ifdef _WIN32
  #if defined(HAVE_RUBY_ENCODING_H) && HAVE_RUBY_ENCODING_H
    VALUE ospath;
    const char *utf8;
    int len;
    wchar_t *wide;

    ospath = rb_str_encode_ospath(s);
    utf8 = StringValuePtr(ospath);
    len = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, NULL, 0);
    if (!(wide = (wchar_t *) xmalloc(sizeof(wchar_t) * len))) {
      return TagLib::FileName((const char *) NULL);
    }
    MultiByteToWideChar(CP_UTF8, 0, utf8, -1, wide, len);
    TagLib::FileName filename(wide);
    xfree(wide);
    return filename;
  #else
    const char *filename = StringValuePtr(s);
    return TagLib::FileName(filename);
  #endif
#else
  return StringValuePtr(s);
#endif
}

%}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
