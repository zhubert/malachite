require 'fiddle'
require 'tempfile'

module Malachite
  class Client
    def initialize
      @dylib = open_dlib
    end

    def call_method(name, args)
      method_name = "call#{name.to_s.camelize}"
      @func = Fiddle::Function.new(@dylib[method_name], [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOIDP)
      ptr = @func.call(Malachite.dump_json(args))
      Malachite.load_json(ptr.to_s)
    end

    # Malachite::Client.upcase(["foo", "bar"])
    def self.method_missing(name, args)
      new.call_method(name, args)
    end

    private

    def open_dlib
      Fiddle.dlopen(shared_object_path)
    end

    def shared_object_path
      Malachite::Compiler.new.compile
    end
  end
end
