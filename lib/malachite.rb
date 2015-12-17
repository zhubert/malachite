require 'malachite/version'
fail "Malachite #{Malachite::VERSION} does not support Ruby 1.9" if RUBY_VERSION < '2.0.0'

require 'json'
require 'fiddle'

require 'malachite/errors'
require 'malachite/client'
require 'malachite/compiler'

module Malachite
  def self.load_json(string)
    JSON.load(string)
  end

  def self.dump_json(object)
    JSON.dump(object)
  end
end

if defined?(::Rails::Engine)
  require 'malachite/rails'
else
  fail "Malachite #{Malachite::VERSION} is a Rails-only Gem"
end
