task :default => :test

task :compile => [
  'lib/regin/parser.rb',
  'lib/regin/tokenizer.rb'
]

file 'lib/regin/parser.rb' => 'lib/regin/parser.y' do |t|
  sh "racc -l -o #{t.name} #{t.prerequisites.first}"
  sh "sed -i '' -e 's/  class Parser < Racc::Parser/  class Parser < Racc::Parser #:nodoc: all/' #{t.name}"
  sh "sed -i '' -e 's/  end   # module Regin/end   # module Regin/' #{t.name}"
end

file 'lib/regin/tokenizer.rb' => 'lib/regin/tokenizer.rex' do |t|
  sh "rex -o #{t.name} #{t.prerequisites.first}"
end


require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |t|
  t.ruby_opts = "-w"
end

Rake::Task[:test].enhance [:compile]
