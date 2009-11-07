begin
  require 'mg'
  $spec = MG.new('reginald.gemspec').spec
rescue LoadError
end


require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.libs << 'lib'
  t.ruby_opts = ['-w']
end
