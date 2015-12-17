module Malachite
  class Compiler
    def path_to_tmp_file
      Tempfile.new([@name, 'so']).path
    end

    def path_to_go_file
      Tempfile.new([@name, 'go']).path
    end
  end
  class Client
    def self.method_missing(name, args)
      new("#{name}.go").call(args)
    end
  end
end
