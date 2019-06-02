$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ccrm_import_accounts/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ccrm_import_accounts"
  s.version     = CcrmImportAccounts::VERSION
  s.authors     = ["Gabriel Rios"]
  s.email       = ["gabrielfalcaorios@gmail.com"]
  s.licenses    = ["MIT"]
  s.homepage    = "http://github.com/orbitalimpact/Cos-CRM-Account-Importer"
  s.summary     = "A simple plugin to import accounts into Cos CRM"
  s.description = "A simple plugin to import accounts into Cos CRM Edited by georgTW@github to work with the latest CCRM version (0.14.0)"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  # s.add_dependency "rails", "~> 4.2.6"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency "mysql2"
end
