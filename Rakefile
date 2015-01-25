require 'xcjobs'

def destinations
  [ 'name=iPad 2,OS=8.1',
    'name=iPad Air,OS=8.1',
    'name=iPhone 4s,OS=8.1',
    'name=iPhone 5,OS=8.1',
    'name=iPhone 5s,OS=8.1',
    'name=iPhone 6,OS=8.1',
    'name=iPhone 6 Plus,OS=8.1'
  ]
end

namespace :test do
  xcode_test :ios do |t|
    t.project = 'Base32'
    t.scheme = 'Base32-iOS'
    t.sdk = 'iphonesimulator'
    t.configuration = 'Release'
    t.build_dir = 'build'
    destinations.each do |destination|
      t.add_destination(destination)
    end
    t.formatter = 'xcpretty -c'
  end

  xcode_test :osx do |t|
    t.project = 'Base32'
    t.scheme = 'Base32-Mac'
    t.sdk = 'macosx'
    t.configuration = 'Release'
    t.build_dir = 'build'
    t.formatter = 'xcpretty -c'
  end

  xcode_test :SecEncodeTransformTests do |t|
    t.project = 'Base32'
    t.scheme = 'SecEncodeTransformTests'
    t.sdk = 'macosx'
    t.configuration = 'Release'
    t.build_dir = 'build'
    t.formatter = 'xcpretty -c'
  end
end
