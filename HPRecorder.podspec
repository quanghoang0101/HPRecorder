#
#  Be sure to run `pod spec lint HPRecorder.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "HPRecorder"
  spec.version      = "1.0.1"
  spec.summary      = "A recorder audio for iOS"
  spec.description  = "A recorder audio for iOS, simple to integrate, calculated percent of loudness"
  spec.homepage     = "https://github.com/quanghoang0101/HPRecorder"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Hoang" => "quanghoang0101@ayahoo.com.vn" }
  spec.ios.deployment_target = "10.0"
  spec.source       = { :git => "https://github.com/quanghoang0101/HPRecorder.git", :tag => "#{spec.version}" }
  spec.source_files  = "HPRecorder/**/*.{swift}"
  spec.swift_version = "5"

end
