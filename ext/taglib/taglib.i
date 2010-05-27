%module taglib
%{
#include <taglib/taglib.h>
#include <taglib/tfile.h>
#include <taglib/fileref.h>
#include <taglib/tag.h>
%}

/*
enum ReadStyle {
  Fast, Average, Accurate
};
*/

// Undefine macro
#define TAGLIB_EXPORT

%include <taglib/taglib.h>
%include <taglib/tfile.h>
%include <taglib/fileref.h>
%include <taglib/tag.h>

%{
typedef TagLib::AudioProperties::ReadStyle ReadStyle;
using namespace TagLib;
%}

// vim: set filetype=cpp sw=4 ts=4 noexpandtab:
