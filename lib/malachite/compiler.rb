module Malachite
  class Compiler
    def initialize(file_path, name)
      @file_path = file_path
      @name = name
      @go_file = path_to_go_file
    end

    def compile
      return path_to_tmp_file if File.exist?(path_to_tmp_file)
      compile!
    end

    private

    def compile!
      copy_boilerplate_to_tmp
      unless system('go', 'build', '-buildmode=c-shared', '-o', path_to_tmp_file.to_s, @go_file.to_s)
        fail Malachite::ConfigError, "Unable to Build Shared Library for #{@file_path}"
      end
      path_to_tmp_file
    end

    def copy_boilerplate_to_tmp
      File.open(@go_file, 'w') do |file|
        file.puts "package main\n"
        file.puts "import \"encoding/json\"\n"
        file.puts "import \"C\"\n"
        file.puts munged_source
        file.puts munged_boilerplate
      end
    end

    def munged_boilerplate
      boiler = File.read(File.expand_path('../boilerplate.go.tmpl', __FILE__))
      boiler.gsub(/XXXXXX/, "#{handler_type(munged_source)}{}")
    end

    def munged_source
      source_go = File.read(@file_path)
      source_go.gsub(/package main/, '')
    end

    def handler_type(handler_code)
      match = /^func Handler\(\w+ (.*?)\)/.match(handler_code)
      match[1]
    end
  end
end
