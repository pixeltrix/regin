Gem::Specification.new do |s|
  s.name        = 'reginald'
  s.version     = '0.1.1'
  s.date        = '2009-12-05'
  s.summary     = 'Ruby Regexp syntax parser'

  s.files = Dir['lib/**/*.rb']

  s.has_rdoc = true
  s.extra_rdoc_files = %w[README.rdoc LICENSE]
  s.rdoc_options << '--title' << 'Reginald' <<
                     '--main' << 'README.rdoc'

  s.author   = 'Joshua Peek'
  s.email    = 'josh@joshpeek.com'
  s.homepage = 'http://github.com/josh/reginald'
end
