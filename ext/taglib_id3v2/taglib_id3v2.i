%module "TagLib::ID3v2"
%{
#include <taglib/id3v2frame.h>
#include <taglib/id3v2framefactory.h>
#include <taglib/id3v2tag.h>

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

%include <std_list.i>

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

namespace TagLib {
  namespace ID3v2 {
    class FrameFactory;
  }
}

%ignore TagLib::ID3v2::Frame::Header;
%include <taglib/id3v2frame.h>

%apply SWIGTYPE *DISOWN { TagLib::ID3v2::Frame *frame };
%include <taglib/id3v2tag.h>
%clear TagLib::ID3v2::Frame *;

%include <taglib/id3v2framefactory.h>

%extend TagLib::ID3v2::Tag {
  const FrameList &frameList(const char *frameID) const {
    // Triggers the implicit conversion to ByteVector in C++.
    return $self->frameList(frameID);
  }
}

// Resolve overloading conflict with setText(String)
%rename("field_list=") TagLib::ID3v2::TextIdentificationFrame::setText(const StringList &);
%rename("from_data") TagLib::ID3v2::TextIdentificationFrame::TextIdentificationFrame(const ByteVector &);

%include <taglib/attachedpictureframe.h>
%include <taglib/commentsframe.h>
%include <taglib/generalencapsulatedobjectframe.h>
%include <taglib/popularimeterframe.h>
%include <taglib/privateframe.h>
%include <taglib/relativevolumeframe.h>
%include <taglib/textidentificationframe.h>
%include <taglib/uniquefileidentifierframe.h>
%include <taglib/unknownframe.h>
%include <taglib/unsynchronizedlyricsframe.h>
%include <taglib/urllinkframe.h>

%extend TagLib::ID3v2::Frame {
  TagLib::ID3v2::AttachedPictureFrame *toAttachedPictureFrame() {
    return static_cast<TagLib::ID3v2::AttachedPictureFrame *>($self);
  }
  TagLib::ID3v2::CommentsFrame *toCommentsFrame() {
    return static_cast<TagLib::ID3v2::CommentsFrame *>($self);
  }
  TagLib::ID3v2::GeneralEncapsulatedObjectFrame *toGeneralEncapsulatedObjectFrame() {
    return static_cast<TagLib::ID3v2::GeneralEncapsulatedObjectFrame *>($self);
  }
  TagLib::ID3v2::PopularimeterFrame *toPopularimeterFrame() {
    return static_cast<TagLib::ID3v2::PopularimeterFrame *>($self);
  }
  TagLib::ID3v2::PrivateFrame *toPrivateFrame() {
    return static_cast<TagLib::ID3v2::PrivateFrame *>($self);
  }
  TagLib::ID3v2::RelativeVolumeFrame *toRelativeVolumeFrame() {
    return static_cast<TagLib::ID3v2::RelativeVolumeFrame *>($self);
  }
  TagLib::ID3v2::TextIdentificationFrame *toTextIdentificationFrame() {
    return static_cast<TagLib::ID3v2::TextIdentificationFrame *>($self);
  }
  TagLib::ID3v2::UserTextIdentificationFrame *toUserTextIdentificationFrame() {
    return static_cast<TagLib::ID3v2::UserTextIdentificationFrame *>($self);
  }
  TagLib::ID3v2::UniqueFileIdentifierFrame *toUniqueFileIdentifierFrame() {
    return static_cast<TagLib::ID3v2::UniqueFileIdentifierFrame *>($self);
  }
  TagLib::ID3v2::UnknownFrame *toUnknownFrame() {
    return static_cast<TagLib::ID3v2::UnknownFrame *>($self);
  }
  TagLib::ID3v2::UnsynchronizedLyricsFrame *toUnsynchronizedLyricsFrame() {
    return static_cast<TagLib::ID3v2::UnsynchronizedLyricsFrame *>($self);
  }
  TagLib::ID3v2::UrlLinkFrame *toUrlLinkFrame() {
    return static_cast<TagLib::ID3v2::UrlLinkFrame *>($self);
  }
  TagLib::ID3v2::UserUrlLinkFrame *toUserUrlLinkFrame() {
    return static_cast<TagLib::ID3v2::UserUrlLinkFrame *>($self);
  }
}

// Needed so that SWIG correctly wraps TagLib::List::Iterator,
// which is a std::list::iterator.
%template(FrameStdList) std::list<TagLib::ID3v2::Frame *>;

%template(FrameList) TagLib::List<TagLib::ID3v2::Frame *>;

// vim: set filetype=cpp sw=2 ts=2 expandtab:
