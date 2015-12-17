module Malachite
  class Compiler
    def initialize
      @compiled_file = path_to_compiled_file
    end

    def compile
      return @compiled_file if File.exist?(@compiled_file)
      compile!
    end

    private

    def compile!
      copy_boilerplate_to_tmp
      go_files = Dir["#{Rails.root.join('tmp')}/*.go"]
      unless system('go', 'build', '-buildmode=c-shared', '-o', @compiled_file, *go_files)
        fail Malachite::ConfigError, 'Unable to Build Shared Library'
      end
      path_to_compiled_file
    end

    def copy_boilerplate_to_tmp
      source_files = Dir["#{Rails.root.join('app', 'go')}/*.go"].reject { |f| f['test'] }
      source_files.each do |f|
        File.open(path_to_tmp_file(f), 'w') do |file|
          file.puts 'package main'
          file.puts "import \"C\""
          file.puts source_file(f)
          file.puts exporter_boilerplate(f)
          file.close
        end
      end
      File.open(Rails.root.join('tmp', 'main.go').to_s, 'w') do |file|
        file.puts main_boilerplate
        file.close
      end
    end

    def source_file(f)
      source = File.read(f)
      source.gsub(/package main/, '')
    end

    def main_boilerplate
      File.read(File.expand_path('../main.go.tmpl', __FILE__))
    end

    def exporter_boilerplate(file)
      exporter = File.read(File.expand_path('../exporter.go.tmpl', __FILE__))
      method_name, method_type = extract_method_and_type(file)
      exporter.gsub(/YYYYYY/, "#{method_type}{}").gsub(/XXXXXX/, method_name)
    end

    def extract_method_and_type(source_file_path)
      handler_code = File.read(source_file_path)
      match = /^func Handle(.*?)\(\w+ (.*?)\)/.match(handler_code)
      [match[1], match[2]]
    end

    def path_to_tmp_file(file)
      basename = File.basename(file, '.go')
      Rails.root.join('tmp', "#{basename}.go").to_s
    end

    def path_to_compiled_file
      Rails.root.join('tmp', 'malachite.so').to_s
    end
  end
end
