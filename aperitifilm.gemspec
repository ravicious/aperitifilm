# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aperitifilm/version'

Gem::Specification.new do |spec|
  spec.name          = "aperitifilm"
  spec.version       = Aperitifilm::VERSION
  spec.authors       = ["Rafał Cieślak"]
  spec.email         = ["ravicious@gmail.com"]
  spec.summary       = %q{Let's you see which movies you and your friends on Filmweb would like to watch the most together.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nokogiri", "~> 1.6.5"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10.1"
end
