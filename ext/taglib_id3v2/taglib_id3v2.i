%module "TagLib::ID3v2"
%{
#include <taglib/id3v2frame.h>
#include <taglib/id3v2framefactory.h>
#include <taglib/id3v2tag.h>
#include <taglib/id3v2header.h>

#include <taglib/attachedpictureframe.h>
#include <taglib/commentsframe.h>
#include <taglib/generalencapsulatedobjectframe.h>
#include <taglib/popularimeterframe.h>
#include <taglib/privateframe.h>
#include <taglib/relativevolumeframe.h>
#include <taglib/textidentificationframe.h>
#include <taglib/uniquefileidentifierframe.h>
#include <taglib/unknownframe.h>
#include <taglib/unsynchronizedlyricsframe.h>
#include <taglib/urllinkframe.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

namespace TagLib {
  namespace ID3v2 {
    class FrameFactory;
  }
}

%{
VALUE taglib_id3v2_frame_to_ruby_object(const TagLib::ID3v2::Frame *frame) {
  TagLib::ByteVector id = frame->frameID();
  void *f = SWIG_as_voidptr(frame);
  swig_type_info *ti;
  if (dynamic_cast<const TagLib::ID3v2::UnknownFrame *>(frame))
    ti = SWIGTYPE_p_TagLib__ID3v2__UnknownFrame;
  else if (id == "APIC")
    ti = SWIGTYPE_p_TagLib__ID3v2__AttachedPictureFrame;
  else if (id == "COMM")
    ti = SWIGTYPE_p_TagLib__ID3v2__CommentsFrame;
  else if (id == "GEOB")
    ti = SWIGTYPE_p_TagLib__ID3v2__GeneralEncapsulatedObjectFrame;
  else if (id == "POPM")
    ti = SWIGTYPE_p_TagLib__ID3v2__PopularimeterFrame;
  else if (id == "PRIV")
    ti = SWIGTYPE_p_TagLib__ID3v2__PrivateFrame;
  else if (id == "RVAD" || id == "RVA2")
    ti = SWIGTYPE_p_TagLib__ID3v2__RelativeVolumeFrame;
  else if (id == "TXXX")
    ti = SWIGTYPE_p_TagLib__ID3v2__UserTextIdentificationFrame;
  else if (id.startsWith("T"))
    ti = SWIGTYPE_p_TagLib__ID3v2__TextIdentificationFrame;
  else if (id == "UFID")
    ti = SWIGTYPE_p_TagLib__ID3v2__UniqueFileIdentifierFrame;
  else if (id == "USLT")
    ti = SWIGTYPE_p_TagLib__ID3v2__UnsynchronizedLyricsFrame;
  else if (id == "WXXX")
    ti = SWIGTYPE_p_TagLib__ID3v2__UserUrlLinkFrame;
  else if (id.startsWith("W"))
    ti = SWIGTYPE_p_TagLib__ID3v2__UrlLinkFrame;
  else
    ti = SWIGTYPE_p_TagLib__ID3v2__Frame;
  return SWIG_NewPointerObj(f, ti, 0);
}

VALUE taglib_id3v2_framelist_to_ruby_array(TagLib::ID3v2::FrameList *list) {
  VALUE ary = rb_ary_new2(list->size());
  for (TagLib::ID3v2::FrameList::ConstIterator it = list->begin(); it != list->end(); it++) {
    VALUE s = taglib_id3v2_frame_to_ruby_object(*it);
    rb_ary_push(ary, s);
  }
  return ary;
}
%}

%include <taglib/id3v2header.h>

%ignore TagLib::ID3v2::Frame::Header;
%include <taglib/id3v2frame.h>

%typemap(out) TagLib::ID3v2::FrameList & {
  $result = taglib_id3v2_framelist_to_ruby_array($1);
}
%apply TagLib::ID3v2::FrameList & { const TagLib::ID3v2::FrameList & };

%apply SWIGTYPE *DISOWN { TagLib::ID3v2::Frame *frame };
%ignore TagLib::ID3v2::Tag::removeFrame(Frame *, bool);
%include <taglib/id3v2tag.h>
%clear TagLib::ID3v2::Frame *;

%include <taglib/id3v2framefactory.h>

// Resolve overloading conflict with setText(String)
%rename("field_list=") TagLib::ID3v2::TextIdentificationFrame::setText(const StringList &);
%rename("from_data") TagLib::ID3v2::TextIdentificationFrame::TextIdentificationFrame(const ByteVector &);

%include "relativevolumeframe.i"

%include <taglib/attachedpictureframe.h>
%include <taglib/commentsframe.h>
%include <taglib/generalencapsulatedobjectframe.h>
%include <taglib/popularimeterframe.h>
%include <taglib/privateframe.h>
%include <taglib/textidentificationframe.h>
%include <taglib/uniquefileidentifierframe.h>
%include <taglib/unknownframe.h>
%include <taglib/unsynchronizedlyricsframe.h>
%include <taglib/urllinkframe.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
