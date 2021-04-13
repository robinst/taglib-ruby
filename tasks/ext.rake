# frozen-string-literal: true

# Extension tasks and cross-compiling

host = 'i686-w64-mingw32'
$plat = ENV['PLATFORM'] || 'i386-mingw32'

taglib_version = ENV['TAGLIB_VERSION'] || '1.9.1'
taglib = "taglib-#{taglib_version}"

tmp = "#{Dir.pwd}/tmp"
tmp_arch = "#{tmp}/#{$plat}"
toolchain_file = "#{Dir.pwd}/ext/win.cmake"
install_dir = "#{tmp_arch}/#{taglib}"
install_dll = "#{install_dir}/bin/libtag.dll"
install_so = "#{install_dir}/lib/libtag.so"
$cross_config_options = ["--with-opt-dir=#{install_dir}"]

taglib_url = "https://github.com/taglib/taglib/archive/v#{taglib_version}.tar.gz"
taglib_options = ['-DCMAKE_BUILD_TYPE=Release',
                  '-DBUILD_EXAMPLES=OFF',
                  '-DBUILD_TESTS=OFF',
                  '-DBUILD_BINDINGS=OFF', # 1.11 builds bindings by default
                  '-DBUILD_SHARED_LIBS=ON', # 1.11 builds static by default
                  '-DWITH_MP4=ON', # WITH_MP4, WITH_ASF only needed with taglib 1.7, will be default in 1.8
                  '-DWITH_ASF=ON'].join(' ')

def configure_cross_compile(ext)
  ext.cross_compile = true
  ext.cross_platform = $plat
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

file "#{tmp_arch}/stage/lib/libtag.dll" => [install_dll] do |f|
  install install_dll, f
end

file install_dll => ["#{tmp}/#{taglib}"] do
  chdir "#{tmp}/#{taglib}" do
    sh %(cmake -DCMAKE_INSTALL_PREFIX=#{install_dir} -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file} #{taglib_options})
    sh 'make VERBOSE=1'
    sh 'make install'
  end
end

task vendor: [install_so]

file install_so => ["#{tmp_arch}/#{taglib}", "#{tmp_arch}/#{taglib}-build", "#{tmp}/#{taglib}"] do
  chdir "#{tmp_arch}/#{taglib}-build" do
    sh %(cmake -DCMAKE_INSTALL_PREFIX=#{install_dir} #{taglib_options} #{tmp}/#{taglib})
    sh 'make install VERBOSE=1'
  end
end

directory "#{tmp_arch}/#{taglib}"
directory "#{tmp_arch}/#{taglib}-build"

file "#{tmp}/#{taglib}" => ["#{tmp}/#{taglib}.tar.gz"] do
  chdir tmp do
    sh "tar xzf #{taglib}.tar.gz"
  end
end

file "#{tmp}/#{taglib}.tar.gz" => [tmp] do |t|
  require 'open-uri'
  puts "Downloading #{taglib_url}"

  File.open(t.name, 'wb') do |f|
    IO.copy_stream(open(taglib_url), f)
  end
end

directory tmp
