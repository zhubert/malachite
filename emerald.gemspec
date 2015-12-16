# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emerald/version'

Gem::Specification.new do |spec|
  spec.name          = 'emerald'
  spec.version       = Emerald::VERSION
  spec.authors       = ['Zack Hubert']
  spec.email         = ['zhubert@gmail.com']

  spec.summary       = 'A RubyGem which enables calling Go code from Ruby.'
  spec.description   = spec.summary
  spec.homepage      = 'http://www.zhubert.com'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('lib/**/*.rb') + %w(Gemfile Rakefile)
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'json', '~> 1.0'
  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
end
