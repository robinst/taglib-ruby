desc "Checks file list in .gemspec against files tracked in Git"
task :gemspec_check do |t|
  exclude = ['.gitignore', '.travis.yml']
  git_files = `git ls-files`.split("\n") - exclude
  gemspec_files = $gemspec.files

  only_in_gemspec = gemspec_files - git_files
  only_in_git = git_files - gemspec_files

  unless only_in_gemspec.empty?
    puts "In gemspec but not in git:"
    puts only_in_gemspec
  end

  unless only_in_git.empty?
    puts "In git but not in gemspec:"
    puts only_in_git
  end
end
