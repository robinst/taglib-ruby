# -*- encoding: utf-8 -*-

$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require 'taglib/version'

Gem::Specification.new do |s|
  s.name        = "taglib-ruby"
  s.version     = TagLib::Version::STRING
  s.authors     = ["Robin Stocker", "Jacob Vosmaer", "Thomas Chevereau"]
  s.email       = ["robin@nibor.org"]
  s.homepage    = "http://robinst.github.io/taglib-ruby/"
  s.licenses    = ["MIT"]
  s.summary     = "Ruby interface for the taglib C++ library"
  s.description = <<DESC
Ruby interface for the taglib C++ library, for reading and writing
meta-data (tags) of many audio formats.

In contrast to other libraries, this one wraps the C++ API using SWIG,
not only the minimal C API. This means that all tags can be accessed.
DESC

  s.require_paths = ["lib"]
  s.requirements = ["taglib (libtag1-dev in Debian/Ubuntu, taglib-devel in Fedora/RHEL)"]

  s.add_development_dependency 'bundler', '~> 1.2'
  s.add_development_dependency 'rake-compiler', '~> 0.9'
  s.add_development_dependency 'shoulda-context', '~> 1.0'
  s.add_development_dependency 'yard', '~> 0.7'
  s.add_development_dependency 'kramdown', '~> 1.0'

  s.extensions = [
    "ext/taglib_base/extconf.rb",
    "ext/taglib_mpeg/extconf.rb",
    "ext/taglib_id3v1/extconf.rb",
    "ext/taglib_id3v2/extconf.rb",
    "ext/taglib_ogg/extconf.rb",
    "ext/taglib_vorbis/extconf.rb",
    "ext/taglib_flac/extconf.rb",
    "ext/taglib_mp4/extconf.rb",
    "ext/taglib_aiff/extconf.rb",
    "ext/taglib_wav/extconf.rb",
  ]
  s.extra_rdoc_files = [
    "CHANGES.md",
    "LICENSE.txt",
    "README.md",
  ]
  s.files = [
    ".yardopts",
    "CHANGES.md",
    "Gemfile",
    "Guardfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "docs/default/fulldoc/html/css/common.css",
    "docs/taglib/aiff.rb",
    "docs/taglib/base.rb",
    "docs/taglib/flac.rb",
    "docs/taglib/id3v1.rb",
    "docs/taglib/id3v2.rb",
    "docs/taglib/mp4.rb",
    "docs/taglib/mpeg.rb",
    "docs/taglib/ogg.rb",
    "docs/taglib/riff.rb",
    "docs/taglib/vorbis.rb",
    "docs/taglib/wav.rb",
    "ext/extconf_common.rb",
    "ext/taglib_aiff/extconf.rb",
    "ext/taglib_aiff/taglib_aiff.i",
    "ext/taglib_aiff/taglib_aiff_wrap.cxx",
    "ext/taglib_base/extconf.rb",
    "ext/taglib_base/includes.i",
    "ext/taglib_base/taglib_base.i",
    "ext/taglib_base/taglib_base_wrap.cxx",
    "ext/taglib_flac/extconf.rb",
    "ext/taglib_flac/taglib_flac.i",
    "ext/taglib_flac/taglib_flac_wrap.cxx",
    "ext/taglib_id3v1/extconf.rb",
    "ext/taglib_id3v1/taglib_id3v1.i",
    "ext/taglib_id3v1/taglib_id3v1_wrap.cxx",
    "ext/taglib_id3v2/extconf.rb",
    "ext/taglib_id3v2/relativevolumeframe.i",
    "ext/taglib_id3v2/taglib_id3v2.i",
    "ext/taglib_id3v2/taglib_id3v2_wrap.cxx",
    "ext/taglib_mp4/extconf.rb",
    "ext/taglib_mp4/taglib_mp4.i",
    "ext/taglib_mp4/taglib_mp4_wrap.cxx",
    "ext/taglib_mpeg/extconf.rb",
    "ext/taglib_mpeg/taglib_mpeg.i",
    "ext/taglib_mpeg/taglib_mpeg_wrap.cxx",
    "ext/taglib_ogg/extconf.rb",
    "ext/taglib_ogg/taglib_ogg.i",
    "ext/taglib_ogg/taglib_ogg_wrap.cxx",
    "ext/taglib_vorbis/extconf.rb",
    "ext/taglib_vorbis/taglib_vorbis.i",
    "ext/taglib_vorbis/taglib_vorbis_wrap.cxx",
    "ext/taglib_wav/extconf.rb",
    "ext/taglib_wav/taglib_wav.i",
    "ext/taglib_wav/taglib_wav_wrap.cxx",
    "ext/valgrind-suppressions.txt",
    "ext/win.cmake",
    "lib/taglib.rb",
    "lib/taglib/aiff.rb",
    "lib/taglib/base.rb",
    "lib/taglib/flac.rb",
    "lib/taglib/id3v1.rb",
    "lib/taglib/id3v2.rb",
    "lib/taglib/mp4.rb",
    "lib/taglib/mpeg.rb",
    "lib/taglib/ogg.rb",
    "lib/taglib/version.rb",
    "lib/taglib/vorbis.rb",
    "lib/taglib/wav.rb",
    "taglib-ruby.gemspec",
    "tasks/docs_coverage.rake",
    "tasks/ext.rake",
    "tasks/gemspec_check.rake",
    "tasks/swig.rake",
    "test/base_test.rb",
    "test/data/Makefile",
    "test/data/aiff-sample.aiff",
    "test/data/add-relative-volume.cpp",
    "test/data/crash.mp3",
    "test/data/flac-create.cpp",
    "test/data/flac.flac",
    "test/data/get_picture_data.cpp",
    "test/data/globe_east_540.jpg",
    "test/data/globe_east_90.jpg",
    "test/data/id3v1-create.cpp",
    "test/data/id3v1.mp3",
    "test/data/mp4-create.cpp",
    "test/data/mp4.m4a",
    "test/data/relative-volume.mp3",
    "test/data/sample.mp3",
    "test/data/unicode.mp3",
    "test/data/vorbis-create.cpp",
    "test/data/vorbis.oga",
    "test/data/wav-create.cpp",
    "test/data/wav-dump.cpp",
    "test/data/wav-sample.wav",
    "test/aiff_examples_test.rb",
    "test/aiff_file_test.rb",
    "test/aiff_file_write_test.rb",
    "test/helper.rb",
    "test/fileref_open_test.rb",
    "test/fileref_properties_test.rb",
    "test/fileref_write_test.rb",
    "test/file_test.rb",
    "test/flac_file_test.rb",
    "test/flac_file_write_test.rb",
    "test/id3v1_tag_test.rb",
    "test/id3v2_frames_test.rb",
    "test/id3v2_header_test.rb",
    "test/id3v2_memory_test.rb",
    "test/id3v2_relative_volume_test.rb",
    "test/id3v2_tag_test.rb",
    "test/id3v2_unicode_test.rb",
    "test/id3v2_unknown_frames_test.rb",
    "test/id3v2_write_test.rb",
    "test/mp4_file_test.rb",
    "test/mp4_file_write_test.rb",
    "test/mp4_items_test.rb",
    "test/mpeg_file_test.rb",
    "test/tag_test.rb",
    "test/unicode_filename_test.rb",
    "test/vorbis_file_test.rb",
    "test/vorbis_tag_test.rb",
    "test/wav_examples_test.rb",
    "test/wav_file_test.rb",
    "test/wav_file_write_test.rb",
  ]
end
