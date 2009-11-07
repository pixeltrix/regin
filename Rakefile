begin
  require 'mg'
  $spec = MG.new('reginald.gemspec').spec
rescue LoadError
end


task :default => [:compile, :spec]


task :compile => [
  'lib/reginald/parser.rb',
  'lib/reginald/tokenizer.rb'
]

file 'lib/reginald/parser.rb' => 'lib/reginald/parser.y' do |t|
  sh "racc -l -o #{t.name} #{t.prerequisites.first}"
end

file 'lib/reginald/tokenizer.rb' => 'lib/reginald/tokenizer.rex' do |t|
  sh "rex -o #{t.name} #{t.prerequisites.first}"
end


require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.libs << 'lib'
  t.ruby_opts = ['-w']
end
