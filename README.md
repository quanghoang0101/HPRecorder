# HPRecorder

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/HPRecorder.svg?style=flat)](https://cocoapods.org/pods/HPRecorder)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/quanghoang0101/HPRecorder.svg?style=flat
)](https://github.com/quanghoang0101/HPRecorder/issues?state=open)
![Build](https://travis-ci.com/quanghoang0101/HPRecorder.svg?branch=master)
[![codecov](https://codecov.io/gh/quanghoang0101/HPRecorder/branch/master/graph/badge.svg)](https://codecov.io/gh/quanghoang0101/HPRecorder)

A recorder audio for iOS, simple to integrate, calculated percent of loudness.

![sample](https://media.giphy.com/media/QTbEe6peUEFxxXDxLh/giphy.gif)

# Installation
#### CocoaPods
```
pod 'HPRecorder'
```
#### Manually
Copy the `HPRecorder` folder to your project.

## Conguration
```Swift
// Time interval to get percent of loudness
open var timeInterVal: TimeInterval = 0.3
// File name of audio
open var audioFilename: URL!
// Audio input: default speaker, bluetooth
open var audioInput: AVAudioSessionPortDescription!
```
## Monitor recorder
```Swift 
// Recorder did finish
open var recorderDidFinish: ((_ recocorder: AVAudioRecorder, _ url: URL, _  success: Bool) -> Void)?
// Recorder occur error
open var recorderOccurError: ((_ recocorder: AVAudioRecorder, _ error: Error) -> Void)?
// Percent of loudness
open var percentLoudness: ((_ percent: Float) -> Void)?
```

## Usage

### Setup
Add `import HPRecorder` in your file
In `Info.plist` file of project, you MUST add `Privacy - Microphone Usage Description` key to can use microphone permission.

## Requirements
Swift 5.0

iOS 10.0+

Xcode 10.2+

## Contributing
Forks, patches and other feedback are welcome.

## Creator
[Quang Hoang](https://github.com/quanghoang0101) 

[Blog](https://medium.com/@phanquanghoang)

## License
HPRecorder is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
