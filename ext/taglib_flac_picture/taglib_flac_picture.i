%module "TagLib::FLAC"
%{
#include <taglib/taglib.h>
#include <taglib/flacpicture.h>
%}

%include "../taglib_base/includes.i"
%include "../taglib_flac_picture/includes.i"
%import(module="taglib_base") "../taglib_base/taglib_base.i"

%ignore TagLib::FLAC::MetadataBlock::render; // Only useful internally.
%include <taglib/flacmetadatablock.h>

%ignore TagLib::FLAC::Picture::render; // Only useful internally.
%include <taglib/flacpicture.h>
