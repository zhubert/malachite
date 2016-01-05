module Malachite
  def self.hook_rails!
    Dir.glob(Rails.root.join('tmp', '*.so')).each do |file|
      File.delete(file)
    end
    Dir.glob(Rails.root.join('tmp', '*.go')).each do |file|
      File.delete(file)
    end
    Dir.glob(Rails.root.join('tmp', '*.h')).each do |file|
      File.delete(file)
    end
    Malachite::Compiler.new.compile if Malachite.precompile?
  end
  class MalachiteRailtie < Rails::Railtie
    rake_tasks do
      load 'malachite/tasks/malachite.rake'
    end
    initializer 'malachite.configure_rails_initialization' do
      Malachite.hook_rails!
    end
  end
end
