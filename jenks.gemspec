# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jenks/version'

Gem::Specification.new do |spec|
  spec.name          = 'jenks'
  spec.version       = Jenks::VERSION
  spec.authors       = ['Clinton Judy']
  spec.email         = ['clinton@j-udy.com']
  spec.summary       = "Jenks' Natural Breaks Algorithm in Ruby."
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\/}/)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'guard', '~> 2.6.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.3.1'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
end
