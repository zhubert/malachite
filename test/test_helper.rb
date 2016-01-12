require 'fileutils'
require 'pathname'
module Rails
  Engine = {}
  def self.root
    Pathname.new(Dir.pwd)
  end
  class Railtie
    def self.rake_tasks; end
    def self.initializer(_); end
  end
end
require 'malachite'
require 'minitest/autorun'
require 'minitest/pride'
