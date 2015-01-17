include FileUtils::Verbose

namespace :test do
  task :prepare do
    mkdir_p "Tests/OnkyoKit Tests.xcodeproj/xcshareddata/xcschemes"
    cp Dir.glob('Tests/Schemes/*.xcscheme'), "Tests/OnkyoKit Tests.xcodeproj/xcshareddata/xcschemes/"
  end

  desc "Run the OnkyoKit Tests for Mac OS X"
  task :osx => :prepare do
    sh('xcodebuild -workspace OnkyoKit.xcworkspace -scheme "OS X Tests" clean test | xcpretty -c')
    tests_failed('OSX') unless $?.success?
  end
end

desc "Run the OnkyoKit Tests for iOS & Mac OS X"
task :test do
  # Rake::Task['test:ios'].invoke
  Rake::Task['test:osx'].invoke
end

task :default => 'test:osx'


private

def tests_failed(platform)
  puts red("#{platform} unit tests failed")
  exit $?.exitstatus
end

def red(string)
  "\033[0;31m! #{string}"
end
