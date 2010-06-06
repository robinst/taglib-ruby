%module "TagLib::MPEG"
%{
#include <taglib/taglib.h>
#include <taglib/tfile.h>
#include <taglib/mpegproperties.h>
#include <taglib/mpegfile.h>
%}

%include <std_list.i>

%import(module="taglib/base") "../base/base.i"

namespace TagLib {
  namespace MPEG {
    class Properties;
  }
}

%rename(id3v1_tag) TagLib::MPEG::File::ID3v1Tag;
%rename(id3v2_tag) TagLib::MPEG::File::ID3v2Tag;
%rename(set_id3v2_frame_factory) TagLib::MPEG::File::setID3v2FrameFactory;

%include <taglib/mpegfile.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
