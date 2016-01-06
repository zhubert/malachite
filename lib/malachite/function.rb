require 'fiddle'

module Malachite
  class Function
    def initialize(name, args)
      @name = name
      @args = args
    end

    def call
      Malachite.from_function_cache(@name).call(@args).to_value
    end
  end
end
