require 'malachite/version'
fail "Malachite #{Malachite::VERSION} does not support Ruby < 2.0.0" if RUBY_VERSION < '2.0.0'

require 'json'
require 'fiddle'

require 'malachite/errors'
require 'malachite/function_cache'
require 'malachite/function'
require 'malachite/client'
require 'malachite/file_compiler'
require 'malachite/compiler'

module Malachite
  DEFAULTS = {
    precompile: false
  }

  def self.options
    @options ||= DEFAULTS.dup
  end

  def self.options=(opts)
    @options = opts
  end

  def self.precompile?
    Malachite.options.fetch(:precompile, false)
  end

  def self.method_missing(name, args)
    Malachite::Client.new(name, args).call
  end

  def self.load_json(string)
    JSON.parse(string)
  end

  def self.dump_json(object)
    JSON.generate(object)
  end
end

if defined?(::Rails::Engine)
  require 'malachite/railtie'
else
  fail "Malachite #{Malachite::VERSION} requires Rails"
end
