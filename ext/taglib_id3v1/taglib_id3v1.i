%module "TagLib::ID3v1"
%{
#include <taglib/id3v1tag.h>
%}

%include "../taglib_base/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%include <taglib/id3v1tag.h>

// vim: set filetype=cpp sw=2 ts=2 expandtab:
