desc "Show the coverage of the actual API in ext/ by the API docs in docs/"
task :docs_coverage do |t|
  def sort(objects)
    objects.sort_by { |obj| obj.path }
  end

  def synthetic_methods(cls)
    methods = cls.inherited_meths
    methods.map do |m|
      YARD::CodeObjects::MethodObject.new(cls, m.name)
    end
  end

  YARD.parse("ext/**/*_wrap.cxx")
  ext_codeobjects = sort(YARD::Registry.all)

  YARD::Registry.clear
  YARD.parse("docs/**/*.rb")
  docs_classes = YARD::Registry.all(:class)
  docs_others = YARD::Registry.all(:module, :method)
  docs_codeobjects = sort(docs_classes + docs_others)

  # SWIG generates methods for base classes in the subclasses too, we
  # don't want them appearing in the "only in ext" list.
  inherited_methods = docs_classes.map { |c| synthetic_methods(c) }.flatten

  only_in_ext = (ext_codeobjects - docs_codeobjects - inherited_methods)
  only_in_docs = (docs_codeobjects - ext_codeobjects)

  unless only_in_ext.empty?
    puts
    puts "=== Only in ext (to document): "
    puts only_in_ext
    p only_in_ext[4].explicit
  end
  unless only_in_docs.empty?
    puts
    puts "=== Only in docs (typo?): "
    puts only_in_docs
  end
end
