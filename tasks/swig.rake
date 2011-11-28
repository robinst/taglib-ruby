# Tasks for generating SWIG wrappers in ext

def run_swig(mod)
  swig = `which swig`.chomp
  if swig.empty?
    swig = `which swig2.0`.chomp
  end
  sh "cd ext/#{mod} && #{swig} -c++ -ruby -autorename -initname #{mod} -I/usr/include #{mod}.i"
end

task :swig =>
  ['ext/taglib_base/taglib_base_wrap.cxx',
   'ext/taglib_mpeg/taglib_mpeg_wrap.cxx',
   'ext/taglib_id3v2/taglib_id3v2_wrap.cxx']

file 'ext/taglib_base/taglib_base_wrap.cxx' => 'ext/taglib_base/taglib_base.i' do
  run_swig('taglib_base')
end

file 'ext/taglib_mpeg/taglib_mpeg_wrap.cxx' => 'ext/taglib_mpeg/taglib_mpeg.i' do
  run_swig('taglib_mpeg')
end

file 'ext/taglib_id3v2/taglib_id3v2_wrap.cxx' => 'ext/taglib_id3v2/taglib_id3v2.i' do
  run_swig('taglib_id3v2')
end
