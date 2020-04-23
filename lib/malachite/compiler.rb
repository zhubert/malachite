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

      if modified_go_files == []
        raise Malachite::BuildError, 'Nothing to build, there are no Go files in tmp'
      end

      output=`CGO_ENABLED=1 go build -buildmode=c-shared -o #{@compiled_file} #{modified_go_files} 2>&1`; result=$?.success?
      # unless system({ 'CGO_ENABLED' => '1' }, 'go', 'build', '-buildmode=c-shared', '-o', @compiled_file, *modified_go_files)
      if result
        raise Malachite::BuildError, "Unable to Build Shared Library: #{output}"
      end

      unless File.exist?(@compiled_header)
        raise Malachite::BuildError, 'Unable to Build Header File'
      end

      unless File.exist?(@compiled_file)
        raise Malachite::BuildError, 'Unable to Build Shared Object'
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

    def path_to_compiled_header
      Rails.root.join('tmp', 'malachite.h').to_s
    end
  end
end
