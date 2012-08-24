%module "TagLib::MP4"
%{
#include <taglib/taglib.h>
#include <taglib/mp4file.h>
#include <taglib/mp4properties.h>
#include <taglib/mp4tag.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

namespace TagLib {
  namespace MP4 {
    class Properties;
  }
}

%include <taglib/mp4properties.h>
%include <taglib/mp4tag.h>

%include <taglib/mp4file.h>
// vim: set filetype=cpp sw=2 ts=2 expandtab:
