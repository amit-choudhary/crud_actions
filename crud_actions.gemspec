$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "crud_actions/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "crud_actions"
  s.version     = CrudActions::VERSION
  s.authors     = ["Amit Choudhary"]
  s.email       = ["amitchoudhary1008@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of CrudActions."
  s.description = "TODO: Description of CrudActions."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "sqlite3"
end
