%module "TagLib::Ogg"
%{
#include <taglib/taglib.h>
#include <taglib/oggfile.h>
#include <taglib/flacpicture.h>
#include <taglib/xiphcomment.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"
%include "../taglib_flac_picture/includes.i"
%import(module="taglib_flac_picture") "../taglib_flac_picture/taglib_flac_picture.i"

%typemap(out) TagLib::Ogg::FieldListMap {
  $result = taglib_ogg_fieldlistmap_to_ruby_hash(*$1);
}
%apply TagLib::Ogg::FieldListMap { const TagLib::Ogg::FieldListMap & };

%include <taglib/oggfile.h>

%apply SWIGTYPE *DISOWN { TagLib::FLAC::Picture *picture };
// Don't expose second parameter, memory should be freed by TagLib
%ignore TagLib::Ogg::XiphComment::removePicture(Picture *, bool);

%ignore TagLib::Ogg::XiphComment::removeField;

%rename("contains?") TagLib::Ogg::XiphComment::contains;

%include <taglib/xiphcomment.h>

%{
  VALUE taglib_ogg_fieldlistmap_to_ruby_hash(const TagLib::Ogg::FieldListMap & map) {
    VALUE hash = rb_hash_new();
    for (TagLib::Ogg::FieldListMap::ConstIterator it = map.begin(); it != map.end(); it++) {
      TagLib::String key = (*it).first;
      TagLib::StringList value = (*it).second;
      VALUE k = taglib_string_to_ruby_string(key);
      VALUE v = taglib_string_list_to_ruby_array(value);
      rb_hash_aset(hash, k, v);
    }
    return hash;
  }
%}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
