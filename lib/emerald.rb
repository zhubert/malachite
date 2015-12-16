require 'emerald/version'
fail "Emerald #{Emerald::VERSION} does not support Ruby 1.9" if RUBY_VERSION < '2.0.0'

require 'json'
require 'fiddle'

require 'emerald/errors'
require 'emerald/client'
require 'emerald/compiler'

module Emerald
  def self.load_json(string)
    JSON.load(string)
  end

  def self.dump_json(object)
    JSON.dump(object)
  end
end

if defined?(::Rails::Engine)
  require 'emerald/rails'
else
  require 'emerald/ruby'
end
