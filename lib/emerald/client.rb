require 'fiddle'
require 'tempfile'

module Emerald
  class Client
    def initialize(file_path)
      @file_path = file_path
      @name = library_name
      @go_file = path_to_go_file
      @func = Fiddle::Function.new(
        open_dlib['call'],
        [Fiddle::TYPE_VOIDP],
        Fiddle::TYPE_VOIDP
      )
    end

    def call(args)
      ptr = @func.call(Emerald.dump_json(args))
      Emerald.load_json(ptr.to_s)
    end

    private

    def open_dlib
      Fiddle.dlopen(shared_object_path)
    end

    def library_name
      File.basename(@file_path, '.go')
    end

    def shared_object_path
      Emerald::Compiler.new(@file_path, @go_file).compile! unless File.exist?(path_to_tmp_file)
      path_to_tmp_file
    end
  end
end
