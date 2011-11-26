# Extension tasks and cross-compiling

host = 'i686-w64-mingw32'
plat = 'x86-mingw32'

tmp = "#{Dir.pwd}/tmp/#{plat}"
toolchain_file = "#{Dir.pwd}/ext/win.cmake"
install_dir = "#{tmp}/install"
install_dll = "#{install_dir}/bin/libtag.dll"
$cross_config_options = ["--with-opt-dir=#{install_dir}"]

taglib_version = '1.7'
taglib = "taglib-#{taglib_version}"
taglib_url = "http://developer.kde.org/~wheeler/files/src/#{taglib}.tar.gz"

def configure_cross_compile(ext)
  ext.cross_compile = true
  ext.cross_config_options.concat($cross_config_options)
  ext.cross_compiling do |gem|
    gem.files << "lib/libtag.dll"
  end
end

require 'rake/extensiontask'
Rake::ExtensionTask.new("taglib_base", $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new("taglib_mpeg", $gemspec) do |ext|
  configure_cross_compile(ext)
end
Rake::ExtensionTask.new("taglib_id3v2", $gemspec) do |ext|
  configure_cross_compile(ext)
end

task :cross => [:taglib] do
  # Mkmf just uses "g++" as C++ compiler, despite what's in rbconfig.rb.
  # So, we need to hack around it by setting CXX to the cross compiler.
  ENV["CXX"] = "#{host}-g++"
  install install_dll, "lib/"
end

task :taglib => [install_dll]

file install_dll => ["#{tmp}/#{taglib}"] do
  chdir "#{tmp}/#{taglib}" do
    sh "cmake -DCMAKE_INSTALL_PREFIX=#{install_dir} -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}"
    sh "make"
    sh "make install"
  end
end

file "#{tmp}/#{taglib}" => ["#{tmp}/#{taglib}.tar.gz"] do
  chdir tmp do
    sh "tar xzf #{taglib}.tar.gz"
  end
end

file "#{tmp}/#{taglib}.tar.gz" => [tmp] do |t|
  require 'open-uri'
  puts "Downloading #{taglib_url}"
  data = open(taglib_url).read()
  break if data == nil
  chdir tmp do
    open(File.basename(t.name), 'wb') do |f|
      f.write(data)
    end
  end
end

directory tmp
