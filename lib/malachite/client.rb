require 'fiddle'
require 'tempfile'

module Malachite
  class Client
    def initialize(file_path)
      @file_path = file_path
      @name = library_name
      @func = Fiddle::Function.new(open_dlib['call'], [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOIDP)
    end

    def call(args)
      ptr = @func.call(Malachite.dump_json(args))
      Malachite.load_json(ptr.to_s)
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
