# Guardfile for tests
# More info at https://github.com/guard/guard#readme

guard :test do
  watch(%r{^lib/(.+)\.so$})     { "test" }
  watch('test/test_helper.rb')  { "test" }
  watch(%r{^test/.+_test\.rb$})
end
