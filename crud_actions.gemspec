$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "crud_actions/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "crud_actions"
  s.version     = CrudActions::VERSION
  s.authors     = ["Amit Choudhary", "Shruti Gupta"]
  s.email       = ["amitchoudhary1008@gmail.com", "inklingviashruti@gmail.com"]
  s.homepage    = "https://github.com/amit-vinsol/crud_actions"
  s.summary     = "CrudActions gem provides seven crud actions with basic definitions."
  s.description = "A method named as has_inherited_actions is added which receives action names as paremeters which need to be defined on controller."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency("activerecord", ">= 4.0", "< 5")
  s.add_dependency("activesupport", ">= 4.0", "< 5")
  s.add_dependency("actionpack", ">= 4.0", "< 5")

  s.add_development_dependency "sqlite3", '~> 1.3.10'
end
