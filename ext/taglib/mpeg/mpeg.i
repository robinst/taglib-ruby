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

%include <taglib/mpegfile.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
