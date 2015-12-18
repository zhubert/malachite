namespace :malachite do
  desc 'run Go tests'
  task :test do
    test_files = Dir["#{Rails.root.join('app', 'go')}/*.go"]
    system('go', 'test', *test_files)
  end
end
