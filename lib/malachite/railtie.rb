# frozen_string_literal: true

module Malachite
  def self.setup!
    Dir.glob(Rails.root.join('tmp', '*.{so,go,h}')).each do |file|
      File.delete(file)
    end

    Malachite::Compiler.new.compile
  end

  class Railtie < Rails::Railtie
    rake_tasks do
      load 'malachite/tasks/malachite.rake'
    end

    # Executed once in production/staging and before each request in development.
    config.to_prepare do
      Malachite.setup!
    end
  end
end
