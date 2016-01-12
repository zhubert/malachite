require 'pathname'
module Rails
  Engine = {}
  def self.root
    Pathname.new(File.join(Dir.pwd, 'test', 'dummy'))
  end
  class Railtie
    def self.rake_tasks; end

    def self.initializer(_); end
  end
end
