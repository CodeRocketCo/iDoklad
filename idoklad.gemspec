Gem::Specification.new do |s|
  s.name        = 'idoklad'
  s.version     = '2.0.0'
  s.date        = '2020-01-16'
  s.summary     = "iDoklad"
  s.description = "A ruby gem for iDoklad.cz api."
  s.authors     = ["Jiri Prochazka", "Lukas Pokorny"]
  s.email       = %w[prochazka@coderocket.co pokorny@luk4s.cz]
  s.homepage    = 'https://github.com/CodeRocketCo/iDoklad'
  s.license     = 'MIT'
  s.files       = %w[LICENSE.md README.md idoklad.gemspec] + Dir['lib/**/*.rb']
  s.add_runtime_dependency "activesupport", '> 5.0'
  s.add_runtime_dependency "json", '~> 2.3'
  s.add_runtime_dependency "oauth2", '~> 1.4'

  s.add_development_dependency "pry"
  s.add_development_dependency "rest-client", "~> 2.1.0"
  s.add_development_dependency "rspec", "~> 3.9"
  s.add_development_dependency "webmock", "~> 3.6"
end
