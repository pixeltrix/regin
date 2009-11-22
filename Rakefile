task :default => [:compile, :spec]


task :compile => [
  'lib/reginald/parser.rb',
  'lib/reginald/tokenizer.rb'
]

file 'lib/reginald/parser.rb' => 'lib/reginald/parser.y' do |t|
  sh "racc -l -o #{t.name} #{t.prerequisites.first}"
  sh "sed -i '' -e 's/  end   # module Reginald/end   # module Reginald/' #{t.name}"
end

file 'lib/reginald/tokenizer.rb' => 'lib/reginald/tokenizer.rex' do |t|
  sh "rex -o #{t.name} #{t.prerequisites.first}"
end


require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.warning = true
end
