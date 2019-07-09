Gem::Specification.new do |s|
  s.name        = 'idoklad'
  s.version     = '1.0.2'
  s.date        = '2010-07-01'
  s.summary     = "iDoklad"
  s.description = "A ruby gem for iDoklad.cz api."
  s.authors     = ["Jiri Prochazka", "Lukas Pokorny"]
  s.email       = %w[prochazka@coderocket.co pokorny@luk4s.cz]
  s.homepage    = 'https://github.com/CodeRocketCo/iDoklad'
  s.license     = 'MIT'
  s.files       = %w[LICENSE.md README.md idoklad.gemspec] + Dir['lib/**/*.rb']
  s.add_runtime_dependency "json", '~> 2.1'
  s.add_runtime_dependency "oauth2", '~> 1.4'

  s.add_development_dependency "rspec", "~> 3.8"
  s.add_development_dependency "webmock", "~> 3.6"
end
