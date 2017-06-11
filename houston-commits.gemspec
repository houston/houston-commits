$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "houston/commits/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = "houston-commits"
  spec.version       = Houston::Commits::VERSION
  spec.authors       = ["Bob Lail"]
  spec.email         = ["bob.lailfamily@gmail.com"]

  spec.summary       = "Defines an adapter for linking Houston projects to a version control system"
  spec.homepage      = "https://github.com/houston/houston-commits"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]
  spec.test_files = Dir["test/**/*"]

  spec.add_dependency "houston-core", ">= 0.8.0"

  # Implements Houston's VersionControl::GitAdapter
  spec.add_dependency "rugged", "~> 0.25.0"

  # For integration with GitHub
  spec.add_dependency "octokit", "~> 4.6.2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
end
