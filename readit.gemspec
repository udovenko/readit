$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'readit/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'readit'
  s.version = Readit::VERSION
  s.authors = ['Denis Udovenko']
  s.email = ['denis.e.udovenko@gmail.com']
  s.homepage = 'https://github.com/udovenko/readit'
  s.summary = 'Simple announcements implementation for applications without authentication.'
  s.description = 'Readit brings simple announcements to your application.'\
    ' It uses cookie to stores read announcements data and does not require authentication gems.'\
    ' Cookie contains content hash for each read announcement so if model was edited after when'\
    ' user already read its content, he will see updated announcement again.'
  s.license = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_development_dependency 'rails', '4.1.5'
  s.add_development_dependency 'bootstrap-sass', '~> 3.1.1'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rubocop'
end
