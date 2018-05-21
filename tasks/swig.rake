# Tasks for generating SWIG wrappers in ext

# Execute SWIG for the specified extension.
# Arguments:
# mod:: The name of the SWIG wrapper to process.
#
# If the TAGLIB_DIR environment variable points to a directory,
# $TAGLIB_DIR/include will be searched first for taglib headers.
def run_swig(mod)
  swig = `which swig`.chomp
  if swig.empty?
    swig = `which swig2.0`.chomp
  end

  # Standard search location for headers
  include_args = %w{-I/usr/local/include -I/usr/include}

  if ENV.has_key?('TAGLIB_DIR')
    unless File.directory?(ENV['TAGLIB_DIR'])
      abort "When defined, the TAGLIB_DIR environment variable must point to a valid directory."
    end

    # Push it in front to get it searched first.
    include_args.unshift('-I' + ENV['TAGLIB_DIR'] + '/include')
  end

  sh "cd ext/#{mod} && #{swig} -c++ -ruby -autorename -initname #{mod} #{include_args.join(' ')} #{mod}.i"
end

task :swig =>
  ['ext/taglib_base/taglib_base_wrap.cxx',
   'ext/taglib_mpeg/taglib_mpeg_wrap.cxx',
   'ext/taglib_id3v1/taglib_id3v1_wrap.cxx',
   'ext/taglib_id3v2/taglib_id3v2_wrap.cxx',
   'ext/taglib_ogg/taglib_ogg_wrap.cxx',
   'ext/taglib_vorbis/taglib_vorbis_wrap.cxx',
   'ext/taglib_flac/taglib_flac_picture_wrap.cxx',
   'ext/taglib_flac/taglib_flac_wrap.cxx',
   'ext/taglib_mp4/taglib_mp4_wrap.cxx',
   'ext/taglib_aiff/taglib_aiff_wrap.cxx',
   'ext/taglib_wav/taglib_wav_wrap.cxx',
  ]

base_dependencies = ['ext/taglib_base/taglib_base.i', 'ext/taglib_base/includes.i']

file 'ext/taglib_base/taglib_base_wrap.cxx' => base_dependencies do
  run_swig('taglib_base')
end

file 'ext/taglib_mpeg/taglib_mpeg_wrap.cxx' => ['ext/taglib_mpeg/taglib_mpeg.i'] + base_dependencies do
  run_swig('taglib_mpeg')
end

file 'ext/taglib_id3v1/taglib_id3v1_wrap.cxx' => ['ext/taglib_id3v1/taglib_id3v1.i'] + base_dependencies do
  run_swig('taglib_id3v1')
end

file 'ext/taglib_id3v2/taglib_id3v2_wrap.cxx' => ['ext/taglib_id3v2/taglib_id3v2.i'] + base_dependencies do
  run_swig('taglib_id3v2')
end

file 'ext/taglib_ogg/taglib_ogg_wrap.cxx' => ['ext/taglib_ogg/taglib_ogg.i'] + base_dependencies do
  run_swig('taglib_ogg')
end

file 'ext/taglib_vorbis/taglib_vorbis_wrap.cxx' => ['ext/taglib_vorbis/taglib_vorbis.i'] + base_dependencies do
  run_swig('taglib_vorbis')
end

file 'ext/taglib_flac/taglib_flac_picture_wrap.cxx' => ['ext/taglib_flac_picture/taglib_flac_picture.i'] + base_dependencies do
  run_swig('taglib_flac_picture')
end

file 'ext/taglib_flac/taglib_flac_wrap.cxx' => ['ext/taglib_flac/taglib_flac.i', 'ext/taglib_flac_picture/taglib_flac_picture.i'] + base_dependencies do
  run_swig('taglib_flac')
end

file 'ext/taglib_mp4/taglib_mp4_wrap.cxx' => ['ext/taglib_mp4/taglib_mp4.i'] + base_dependencies do
  run_swig('taglib_mp4')
end

file 'ext/taglib_aiff/taglib_aiff_wrap.cxx' => ['ext/taglib_aiff/taglib_aiff.i'] + base_dependencies do
  run_swig('taglib_aiff')
end

file 'ext/taglib_wav/taglib_wav_wrap.cxx' => ['ext/taglib_wav/taglib_wav.i'] + base_dependencies do
  run_swig('taglib_wav')
end
