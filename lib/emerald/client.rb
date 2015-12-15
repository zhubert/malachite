require 'fiddle'
require 'tempfile'

module Emerald
  class Client
    def initialize(file_path)
      @file_path = file_path
      @name = lib_name_from_file_path
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

    def path_to_tmp_file
      Tempfile.new([@name, 'so']).path
    end

    def path_to_go_file
      Tempfile.new([@name, 'go']).path
    end

    def self.method_missing(name, args)
      client = new("#{name.to_s}.go")
      client.call(args)
    end

    private

    def boilerplate_to_tmp
      boiler = File.read(File.expand_path('../boilerplate.go.tmpl', __FILE__))
      source_go = File.read(@file_path)
      trimmed_source = source_go.gsub(/package main/, "")
      substituted_boilerplate = boiler.gsub(/XXXXXX/, "[]string{}")
      File.open(@go_file, "w") do |file|
        file.puts "package main\n"
        file.puts "import \"encoding/json\"\n"
        file.puts "import \"C\"\n"
        file.puts trimmed_source
        file.puts substituted_boilerplate
      end
    end

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
      boilerplate_to_tmp
      unless system('go', 'build', '-buildmode=c-shared', '-o', path_to_tmp_file.to_s, @go_file.to_s)
        raise Emerald::ConfigError, "Unable to Build Shared Library for #{@file_path}"
      end
    end
  end
end
