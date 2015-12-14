require 'fiddle'
require 'tempfile'

module Emerald
  class Client
    def initialize(options = {})
      @file_path = options[:file_path]
      @method = options[:method]
      @name = lib_name_from_file_path
      @func = Fiddle::Function.new(
        open_dlib[@method],
        [Fiddle::TYPE_VOIDP],
        Fiddle::TYPE_VOIDP
      )
    end

    def call(args)
      ptr = @func.call(Emerald.dump_json(args))
      Emerald.load_json(ptr.to_s)
    end

    def path_to_tmp_file
      Tempfile.new([@name, 'so']).path
    end

    def self.method_missing(name, *args)
      client = new(file_path: "#{name}.go", method: name)
      client.call(args)
    end

    private

    def open_dlib
      Fiddle.dlopen(so_path_from_file_path)
    end

    def lib_name_from_file_path
      File.basename @file_path, '.go'
    end

    def so_path_from_file_path
      compile_so! if !File.exist?(path_to_tmp_file)
      path_to_tmp_file
    end

    def compile_so!
      unless system('go', 'build', '-buildmode=c-shared', '-o', path_to_tmp_file.to_s, @file_path.to_s)
        raise Emerald::ConfigError, "Unable to Build Shared Library for #{@file_path}"
      end
    end
  end
end
