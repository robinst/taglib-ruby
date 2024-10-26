# frozen-string-literal: true

require_relative 'build'

# Extension tasks and cross-compiling

host = 'i686-w64-mingw32'
toolchain_file = "#{Dir.pwd}/ext/win.cmake"
install_dll = "#{Build.install_dir}/bin/libtag.dll"
$cross_config_options = ["--with-opt-dir=#{Build.install_dir}"]

taglib_url = "https://github.com/taglib/taglib/archive/v#{Build.version}.tar.gz"
taglib_options = ['-DCMAKE_BUILD_TYPE=Release',
                  '-DBUILD_EXAMPLES=OFF',
                  '-DBUILD_TESTS=OFF',
                  '-DBUILD_TESTING=OFF', # used since 1.13 instead of BUILD_TESTS
                  '-DBUILD_BINDINGS=OFF', # 1.11 builds bindings by default
                  '-DBUILD_SHARED_LIBS=ON', # 1.11 builds static by default
                  '-DWITH_MP4=ON', # WITH_MP4, WITH_ASF only needed with taglib 1.7, will be default in 1.8
                  '-DWITH_ASF=ON'].join(' ')

def configure_cross_compile(ext)
  ext.cross_compile = true
  ext.cross_platform = Build.plat
  ext.cross_config_options.concat($cross_config_options)
  ext.cross_compiling do |gem|
    gem.files << 'lib/libtag.dll'
  end
end

require 'rake/extensiontask'
Rake::ExtensionTask.new('taglib_base', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_mpeg', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_id3v1', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_id3v2', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_ogg', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_vorbis', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_flac_picture', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_flac', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_mp4', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_aiff', $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new('taglib_wav', $gemspec) do |ext|
  configure_cross_compile(ext)
end

task :cross do
  # Mkmf just uses "g++" as C++ compiler, despite what's in rbconfig.rb.
  # So, we need to hack around it by setting CXX to the cross compiler.
  ENV['CXX'] = "#{host}-g++"
end

file "#{Build.tmp_arch}/stage/lib/libtag.dll" => [install_dll] do |f|
  install install_dll, f
end

file install_dll => [Build.source] do
  chdir Build.source do
    sh %(cmake -DCMAKE_INSTALL_PREFIX=#{Build.install_dir} -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file} #{taglib_options})
    sh 'make VERBOSE=1'
    sh 'make install'
  end
end

task vendor: [Build.library]

file Build.library => [Build.install_dir, Build.build_dir, Build.source] do
  chdir Build.build_dir do
    sh %(cmake -DCMAKE_INSTALL_PREFIX=#{Build.install_dir} #{taglib_options} #{Build.source})
    sh 'make install -j 4 VERBOSE=1'
  end
end

directory Build.install_dir
directory Build.build_dir
directory Build.tmp

file Build.source do
  sh "git clone --depth=1 --branch=v#{Build.version} https://github.com/taglib/taglib.git #{Build.source}"
  sh "git -C #{Build.source} submodule init"
  sh "git -C #{Build.source} submodule update --depth=1"
end
