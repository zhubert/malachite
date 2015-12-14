require 'emerald/version'
fail "Emerald #{Emerald::VERSION} does not support Ruby 1.9" if RUBY_VERSION < '2.0.0'

require 'json'
require 'fiddle'

require 'emerald/client'

module Emerald
  def self.load_json(string)
    JSON.load(string)
  end

  def self.dump_json(object)
    JSON.dump(object)
  end
end

require 'emerald/rails' if defined?(::Rails::Engine)
