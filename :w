require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.test_files = FileList.new('spec/lib/buscape_api/*_spec.rb')
  t.verbose = true
end
 
task :default => :test
