%module "TagLib::ID3v2"
%{
#include <taglib/id3v2frame.h>
#include <taglib/id3v2tag.h>
%}

%import(module="taglib/base") "../base/base.i"

namespace TagLib {
  namespace ID3v2 {
    class FrameFactory;
  }
}

%include <taglib/id3v2frame.h>
%include <taglib/id3v2tag.h>
