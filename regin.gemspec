Gem::Specification.new do |s|
  s.name      = 'regin'
  s.version   = '0.3.8'
  s.date      = '2011-03-23'

  s.homepage    = "https://github.com/josh/regin"
  s.summary     = "Ruby Regexp Introspection"
  s.description = <<-EOS
    Regin allows you to introspect on Ruby Regexps.
  EOS

  s.files = [
   "lib/regin.rb",
   "lib/regin/alternation.rb",
   "lib/regin/anchor.rb",
   "lib/regin/atom.rb",
   "lib/regin/character.rb",
   "lib/regin/character_class.rb",
   "lib/regin/collection.rb",
   "lib/regin/expression.rb",
   "lib/regin/group.rb",
   "lib/regin/options.rb",
   "lib/regin/parser.rb",
   "lib/regin/parser.y",
   "lib/regin/tokenizer.rb",
   "lib/regin/tokenizer.rex",
   "lib/regin/version.rb",
   "LICENSE",
   "README.rdoc"
  ]

  s.add_development_dependency 'racc'
  s.add_development_dependency 'rexical'
  s.add_development_dependency 'rspec'

  s.authors           = ["Joshua Peek"]
  s.email             = "josh@joshpeek.com"
  s.rubyforge_project = 'regin'
end
