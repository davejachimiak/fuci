# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuci/version'

Gem::Specification.new do |spec|
  spec.name          = "fuci"
  spec.version       = Fuci::VERSION
  spec.authors       = ["Dave Jachimiak"]
  spec.email         = ["dave.jachimiak@gmail.com"]
  spec.description   = %q{FUCK YOU CI}
  spec.summary       =
  %q{Fuci is a library that covers the general case for running
  recent failures from recent CI (continuous integration) builds
  locally. It includes interfaces for server (e.g. Travis,
  TeamCity) and tester (e.g. RSpec, Cucumber) extensions.}
  spec.homepage      = "https://github.com/davejachimiak/fuci"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest-spec-expect", "~> 0.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "mocha", "~> 0.14"
  spec.add_development_dependency "rake"
end
