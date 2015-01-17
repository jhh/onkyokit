include FileUtils::Verbose

namespace :test do
  desc "Run the OnkyoKit Tests for Mac OS X"
  task :osx do
    sh('xcodebuild -workspace OnkyoKit.xcworkspace -scheme "OS X Tests" clean test | xcpretty -c')
    tests_failed('OSX') unless $?.success?
  end
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
