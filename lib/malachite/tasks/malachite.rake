namespace :malachite do
  desc 'runs all Go tests in app/go'
  task :test do
    test_files = Dir["#{Rails.root.join('app', 'go')}/**/*.go"]
    system({ 'CGO_ENABLED' => '1' }, 'go', 'test', *test_files)
  end

  desc 'deletes any existing shared library and re-compiles'
  task :compile do
    Dir.glob(Rails.root.join('tmp', '*.so')).each do |file|
      File.delete(file)
    end
    Dir.glob(Rails.root.join('tmp', '*.go')).each do |file|
      File.delete(file)
    end
    Dir.glob(Rails.root.join('tmp', '*.h')).each do |file|
      File.delete(file)
    end
    Malachite::Compiler.new.compile
  end
end
