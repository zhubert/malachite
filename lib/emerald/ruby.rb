module Emerald
  class Compiler
    def path_to_tmp_file
      Tempfile.new([@name, 'so']).path
    end
  end
  class Client
    def path_to_go_file
      Tempfile.new([@name, 'go']).path
    end

    def self.method_missing(name, args)
      client = new("#{name}.go")
      client.call(args)
    end
  end
end
