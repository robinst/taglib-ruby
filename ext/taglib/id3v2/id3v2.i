%module "TagLib::ID3v2"
%{
#include <taglib/id3v2frame.h>
#include <taglib/id3v2tag.h>
%}

%include <std_list.i>

%import(module="taglib/base") "../base/base.i"

namespace TagLib {
  namespace ID3v2 {
    class FrameFactory;
  }
}

%ignore TagLib::ID3v2::Frame::Header;
%include <taglib/id3v2frame.h>

%include <taglib/id3v2tag.h>

%extend TagLib::ID3v2::Tag {
  const FrameList &frameList(const char *frameID) const {
    // Triggers the implicit conversion to ByteVector in C++.
    return $self->frameList(frameID);
  }
}

// Needed so that SWIG correctly wraps TagLib::List::Iterator,
// which is a std::list::iterator.
%template(FrameStdList) std::list<TagLib::ID3v2::Frame *>;

%template(FrameList) TagLib::List<TagLib::ID3v2::Frame *>;

// vim: set filetype=cpp sw=2 ts=2 expandtab:
