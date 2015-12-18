require 'fiddle'

module Malachite
  class Function
    def initialize(name, args)
      @name = name
      @args = args
    end

    def call
      fiddle_function.call(@args).to_s
    end

    private

    def fiddle_function
      Fiddle::Function.new(open_dylib[called_method], [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOIDP)
    end

    def called_method
      "call#{@name.to_s.camelize}"
    end

    def open_dylib
      Fiddle.dlopen(shared_object_path)
    rescue Fiddle::DLError
      raise Malachite::DLError
    end

    def shared_object_path
      Malachite::Compiler.new.compile
    end
  end
end
