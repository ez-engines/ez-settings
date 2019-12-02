$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'ez/settings/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'ez-settings'
  s.version     = Ez::Settings::VERSION
  s.authors     = ['Volodya Sveredyuk']
  s.email       = ['sveredyuk@gmail.com']
  s.homepage    = 'https://github.com/ez-engines'
  s.summary     = 'Easy settings engine for Rails app.'
  s.description = 'Easy settings engine for Rails app.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'ez-core',       '~> 0.1.1'

  s.add_dependency 'rails',         '>= 5.0.0', '<= 7.0.0'
  s.add_dependency 'cells-rails',   '~> 0.1.0'
  s.add_dependency 'cells-slim',    '~> 0.0.6'
  s.add_dependency 'redis',         '~> 4.0'
  s.add_dependency 'simple_form',   '>= 5.0.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'fakeredis'
end
