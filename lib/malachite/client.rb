require 'fiddle'
require 'tempfile'

module Malachite
  class Client
    def initialize(file_path)
      @file_path = file_path
      @name = library_name
      @dylib = open_dlib
      @func = Fiddle::Function.new(@dylib['call'], [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOIDP)
    end

    def call(args)
      ptr = @func.call(Malachite.dump_json(args))
      json = Malachite.load_json(ptr.to_s)
      @dylib.close
      json
    end

    private

    def open_dlib
      Fiddle.dlopen(shared_object_path)
    end

    def library_name
      File.basename(@file_path, '.go')
    end

    def shared_object_path
      Malachite::Compiler.new(@file_path, @name).compile
    end
  end
end
