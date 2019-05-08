//
//  Recorder.swift
//  HPRecorder
//
//  Created by Hoang on 5/8/19.
//  Copyright © 2019 Quang Hoang. All rights reserved.
//

import Foundation
import AVFoundation

public class HPRecorder: NSObject {

    open var session: AVAudioSession!
    open var audioRecorder: AVAudioRecorder!

    private var levelTimer = Timer()
    // Time interval to get percent of loudness
    open var timeInterVal: TimeInterval = 0.3
    // File name of audio
    open var audioFilename: URL!
    // Audio input: default speaker, bluetooth
    open var audioInput: AVAudioSessionPortDescription!

    private var isRecording = false

    // Recorder did finish
    open var recorderDidFinish: ((_ recocorder: AVAudioRecorder, _ url: URL, _  success: Bool) -> Void)?
    // Recorder occur error
    open var recorderOccurError: ((_ recocorder: AVAudioRecorder, _ error: Error) -> Void)?
    // Percent of loudness
    open var percentLoudness: ((_ percent: Float) -> Void)?

    open lazy var settings: [String : Any] = {
        return [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }()

    public init(settings: [String : Any], audioFilename: URL, audioInput: AVAudioSessionPortDescription) {
        super.init()
        self.session = AVAudioSession.sharedInstance()
        self.settings = settings
        self.audioFilename = audioFilename
        self.audioInput = audioInput
    }

    public override init() {
        super.init()
        self.session = AVAudioSession.sharedInstance()
        self.audioInput = AudioInput().defaultAudioInput()
    }

    public func askPermission(completion: ((_ allowed: Bool) -> Void)?) {
        if session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            session.requestRecordPermission({(granted: Bool) -> Void in
                completion?(granted)
            })
        } else {
            completion?(false)
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    public func startRecording() {

        if self.audioFilename == nil {
            self.audioFilename = self.getDocumentsDirectory().appendingPathComponent("recording.m4a")
        }

        do {
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [])
            try session.setPreferredInput(self.audioInput)
            try self.session.setActive(true)
        } catch {
            print("Couldn't set Audio session category")
        }

        do {
            audioRecorder = try AVAudioRecorder(url: self.audioFilename, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true

            self.levelTimer = Timer.scheduledTimer(timeInterval: timeInterVal, target: self, selector: #selector(HPRecorder.levelTimerCallback), userInfo: nil, repeats: true)
            isRecording = true

        } catch {
            endRecording()
        }
    }

    public func endRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        audioFilename = nil
        self.levelTimer.invalidate()
    }

    public func pauseRecording() {
        if audioRecorder.isRecording {
            audioRecorder.pause()
            isRecording = false
        }
    }

    public func resumeRecording() {
        if !audioRecorder.isRecording {
            audioRecorder.record()
            isRecording = true
        }
    }

    @objc func levelTimerCallback() {
        audioRecorder.updateMeters()
        let averagePower = audioRecorder.averagePower(forChannel: 0)
        let percentage = self.getIntensityFromPower(decibels: averagePower)
        self.percentLoudness?(percentage*100)
    }

    // Will return a value between 0.0 ... 1.0, based on the decibels
    func getIntensityFromPower(decibels: Float) -> Float {
        let minDecibels: Float = -160
        let maxDecibels: Float = 0

        // Clamp the decibels value
        if decibels < minDecibels {
            return 0
        }
        if decibels >= maxDecibels {
            return 1
        }

        // This value can be adjusted to affect the curve of the intensity
        let root: Float = 2

        let minAmp = powf(10, 0.05 * minDecibels)
        let inverseAmpRange: Float = 1.0 / (1.0 - minAmp)
        let amp: Float = powf(10, 0.05 * decibels)
        let adjAmp = (amp - minAmp) * inverseAmpRange

        return powf(adjAmp, 1.0 / root)
    }
}

extension HPRecorder: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            endRecording()
            self.recorderDidFinish?(recorder, recorder.url, false)
        } else {
            self.recorderDidFinish?(recorder, recorder.url, true)
        }
    }

    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            self.recorderOccurError?(recorder, error)
        }
    }
}
