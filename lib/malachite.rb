# frozen_string_literal: true

require 'malachite/version'
raise "Malachite #{Malachite::VERSION} does not support Ruby < 2.0.0" if RUBY_VERSION < '2.0.0'

require 'json'
require 'fiddle'
require 'active_support/all'

require 'malachite/errors'
require 'malachite/function_cache'
require 'malachite/function'
require 'malachite/client'
require 'malachite/file_compiler'
require 'malachite/compiler'

module Malachite
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

require 'malachite/railtie' if defined?(Rails)
