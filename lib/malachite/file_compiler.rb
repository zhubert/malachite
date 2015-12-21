module Malachite
  class FileCompiler
    def initialize(file)
      @file = file
    end

    def compile
      File.open(path_to_tmp_file(@file), 'w') do |file|
        file.puts 'package main'
        file.puts "import \"C\""
        file.puts source_file(@file)
        file.puts exporter_boilerplate(@file)
        file.close
      end
    end

    private

    def source_file(f)
      source = File.read(f)
      source.gsub(/package main/, '')
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
  end
end
