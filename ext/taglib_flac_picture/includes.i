%{
VALUE taglib_flac_picturelist_to_ruby_array(const TagLib::List<TagLib::FLAC::Picture *> & list) {
  VALUE ary = rb_ary_new2(list.size());
  for (TagLib::List<TagLib::FLAC::Picture *>::ConstIterator it = list.begin(); it != list.end(); it++) {
    TagLib::FLAC::Picture *picture = *it;
    VALUE p = SWIG_NewPointerObj(picture, SWIGTYPE_p_TagLib__FLAC__Picture, 0);
    rb_ary_push(ary, p);
  }
  return ary;
}
%}

%typemap(out) TagLib::List<TagLib::FLAC::Picture *> {
  $result = taglib_flac_picturelist_to_ruby_array($1);
}
