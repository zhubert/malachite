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
      modify_source_files_in_tmp
      unless system('go', 'build', '-buildmode=c-shared', '-o', @compiled_file, *modified_go_files)
        fail Malachite::BuildError, 'Unable to Build Shared Library, is tmp writable?'
      end
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
      File.read(File.expand_path('../main.go.tmpl', __FILE__))
    end

    def path_to_compiled_file
      Rails.root.join('tmp', 'malachite.so').to_s
    end
  end
end
