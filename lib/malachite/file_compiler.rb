# frozen_string_literal: true

module Malachite
  class FileCompiler
    def initialize(file)
      @file = file
    end

    def compile
      File.open(path_to_tmp_file(@file), 'w') do |file|
        if file_has_handle_function?(@file)
          file.puts cgo_tmpl
          file.puts source_file(@file)
          file.puts exporter_boilerplate(@file)
        else
          file.puts File.read(@file)
        end
        file.close
      end
    end

    private

    def cgo_tmpl
      cgo = File.read(File.expand_path('cgo.tmpl', __dir__))
      cgo.gsub(/HEADER/, RbConfig::CONFIG['rubyhdrdir']).gsub(/ARCH/, RbConfig::CONFIG['rubyarchhdrdir'])
    end

    def source_file(file)
      File.readlines(file).drop(1)
    end

    def exporter_boilerplate(file)
      exporter = File.read(File.expand_path('exporter.go.tmpl', __dir__))
      method_name, method_type = extract_method_and_type(file)
      exporter.gsub(/YYYYYY/, "#{method_type}{}").gsub(/XXXXXX/, method_name)
    end

    def file_has_handle_function?(file)
      source = File.read(file)
      match = /^func Handle(.*?)\(\w+ (.*?)\)/.match(source)
      match != nil
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
