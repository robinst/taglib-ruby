%module "TagLib::RIFF"
%{
#include <taglib/taglib.h>
#include <taglib/rifffile.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"


%include <taglib/rifffile.h>


// vim: set filetype=cpp sw=2 ts=2 expandtab:
