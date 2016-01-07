# encoding: utf-8
require File.expand_path('../lib/malachite/version', __FILE__)

Gem::Specification.new do |spec|
  spec.authors       = ['Zack Hubert']
  spec.email         = ['zhubert@gmail.com']
  spec.summary       = 'A RubyGem which enables calling Go code from Rails'
  spec.description   = 'A RubyGem which enables calling Go code from Rails.'
  spec.homepage      = 'http://www.zhubert.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.name          = 'malachite'
  spec.require_paths = ['lib']
  spec.version       = Malachite::VERSION

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_dependency 'json', '~> 1.0'
  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
end
