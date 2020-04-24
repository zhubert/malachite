# frozen_string_literal: true

require 'English'
require 'open3'

module Malachite
  class Compiler
    def initialize
      @compiled_file = path_to_compiled_file
      @compiled_header = path_to_compiled_header
    end

    def compile
      return @compiled_file if File.exist?(@compiled_file) && File.exist?(@compiled_header)

      compile!
    end

    private

    def compile!
      modify_source_files_in_tmp

      raise Malachite::BuildError, 'Nothing to build, there are no Go files in tmp' if modified_go_files == []

      stdout, stderr, status = Open3.capture3({ 'CGO_ENABLED' => '1' }, 'go', 'build', '-buildmode=c-shared', '-o', @compiled_file, *modified_go_files)
      raise Malachite::BuildError, "Unable to Build Shared Library: #{stdout} #{stderr}" unless status.success?
      raise Malachite::BuildError, 'Unable to Build Header File' unless File.exist?(@compiled_header)
      raise Malachite::BuildError, 'Unable to Build Shared Object' unless File.exist?(@compiled_file)

      path_to_compiled_file
    end

    def modify_source_files_in_tmp
      source_files.each do |f|
        Malachite::FileCompiler.new(f).compile
      end

      File.open(Rails.root.join('tmp', 'main.go').to_s, 'w') do |file|
        file.puts main_boilerplate
        file.close
      end
    end

    def modified_go_files
      Dir["#{Rails.root.join('tmp')}/*.go"]
    end

    def source_files
      Dir["#{Rails.root.join('app', 'go')}/**/*.go"].reject { |f| f['test'] }
    end

    def main_boilerplate
      File.read(File.expand_path('main.go.tmpl', __dir__))
    end

    def path_to_compiled_file
      Rails.root.join('tmp', 'malachite.so').to_s
    end

    def path_to_compiled_header
      Rails.root.join('tmp', 'malachite.h').to_s
    end
  end
end
