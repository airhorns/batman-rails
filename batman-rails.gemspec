# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "batman/rails/version"

Gem::Specification.new do |s|
  s.name        = "batman-rails"
  s.version     = Batman::Rails::VERSION
  s.authors     = ["John Duff"]
  s.email       = ["john.duff@jadedpixel.com"]
  s.homepage    = "https://github.com/Shopify/batman-rails"
  s.summary     = %q{Use Batman.js with Rails 3.1}
  s.description = %q{Quickly get started with Batman.js in a Rails 3.1 app. Provides generators to get started and bundles in the latest version of Batman.js.}

  s.rubyforge_project = "batman-rails"

  s.add_dependency "railties", "~> 3.1.0"
  s.add_dependency "thor",     "~> 0.14"
  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "rails",   "~> 3.1.0"
  s.add_development_dependency "mocha"
  s.add_development_dependency "sqlite3"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
