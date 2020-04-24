# frozen_string_literal: true

require 'pathname'
require 'ostruct'

module Rails
  Engine = {}.freeze

  def self.root
    Pathname.new(File.join(Dir.pwd, 'test', 'dummy'))
  end

  class Railtie
    def self.rake_tasks; end

    def self.config
      OpenStruct.new(to_prepare: {})
    end

    def self.initializer(_); end
  end
end
