module Emerald
  class Client
    def path_to_tmp_file
      Rails.root.join('tmp', "#{@name}.so").to_s
    end

    def path_to_go_file
      Rails.root.join('tmp', "#{@name}.go").to_s
    end
    def self.method_missing(name, args)
      file_path = Rails.root.join('app', 'go', "#{name}.go")
      client = new(file_path)
      client.call(args)
    end
  end
  class EmeraldRailtie < Rails::Railtie
    initializer 'emerald.configure_rails_initialization' do
      Dir.glob(Rails.root.join('tmp', '*.so')).each do |file|
        File.delete(file)
      end
      Dir.glob(Rails.root.join('tmp', '*.go')).each do |file|
        File.delete(file)
      end
      Dir.glob(Rails.root.join('tmp', '*.h')).each do |file|
        File.delete(file)
      end
    end
  end
end
