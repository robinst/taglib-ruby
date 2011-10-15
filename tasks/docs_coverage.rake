desc "Show the coverage of the actual API in ext/ by the API docs in docs/"
task :docs_coverage do |t|
  def sort(objects)
    objects.sort_by { |obj| obj.path }
  end

  YARD.parse("ext/**/*_wrap.cxx")
  ext_codeobjects = sort(YARD::Registry.all)
  YARD::Registry.clear
  YARD.parse("docs/**/*.rb")
  docs_codeobjects = sort(YARD::Registry.all(:module, :class, :method))

  only_in_ext = (ext_codeobjects - docs_codeobjects)
  only_in_docs = (docs_codeobjects - ext_codeobjects)

  unless only_in_ext.empty?
    puts
    puts "=== Only in ext (to document): "
    puts only_in_ext
  end
  unless only_in_docs.empty?
    puts
    puts "=== Only in docs (typo?): "
    puts only_in_docs
  end
end
