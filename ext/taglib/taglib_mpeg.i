%module "TagLib::MPEG"
%{
#include <taglib/taglib.h>
#include <taglib/tfile.h>
#include <taglib/mpegproperties.h>
#include <taglib/mpegfile.h>
%}

%import "taglib.i"

namespace TagLib {
  namespace MPEG {
    class Properties;
  }
}

%include <taglib/mpegfile.h>
