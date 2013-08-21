# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_db/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_db"
  spec.version       = SimpleDb::VERSION
  spec.authors       = ["David Muto"]
  spec.email         = ["david.muto@gmail.com"]
  spec.description   = %q{An extremely simple in memory database}
  spec.summary       = %q{Allows in-memory storage of simple values}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "guard-minitest"
end
