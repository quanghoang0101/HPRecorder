//
//  AudioInput.swift
//  HPRecorder
//
//  Created by Hoang on 5/8/19.
//  Copyright © 2019 Quang Hoang. All rights reserved.
//


import Foundation
import AVFoundation

/// Internal current audio input key
private let currentAudioKey = "CurrentAudioKey"

open class AudioInput {

    /**
     Initial
    */
    public init() {}

    /**
     List availble audio inputs
     - Returns: Array of available audio inputs.
     */
    open func availableInput() -> [AVAudioSessionPortDescription] {
        let session = AVAudioSession.sharedInstance()
        var availabeInputs: [AVAudioSessionPortDescription] = []
        do {
            #if os(iOS)
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowBluetooth])
            #else
            try session.setCategory(.playAndRecord, mode: .default, options: [])
            #endif
            availabeInputs = session.availableInputs ?? []
        } catch {
            print("Couldn't set Audio session category")
        }
        return availabeInputs
    }

    /**
     Current audio input
     - Returns: The current audio input. AVAudioSessionPortDescription.
     */
    open func currentAudioInput() -> AVAudioSessionPortDescription {
        if let key = UserDefaults.standard.object(forKey: currentAudioKey) as? String {
            for item in self.availableInput() where key == item.uid {
                return item
            }
        }
        return defaultAudioInput()
    }

    /**
     Default audio input
     - Returns: The app's default audio input. AVAudioSessionPortDescription.
     */
    open func defaultAudioInput() -> AVAudioSessionPortDescription {
        let item = self.availableInput().first!
        return item
    }

    /**
     Change the current portname
     - Parameter portname: Desired portname.
     */
    open func setCurrentAudioInput(_ uid: String) {
        let isContained = availableInput().contains { $0.uid == uid }
        let audioInput = self.availableInput().first(where: {$0.uid == uid})
        let selectedAudioInput = isContained ? audioInput : defaultAudioInput()
        if selectedAudioInput?.uid != currentAudioInput().uid {
            UserDefaults.standard.set(uid, forKey: currentAudioKey)
            UserDefaults.standard.synchronize()
        }
    }

    /**
     Get audio input with portname
     - Parameter portname: name of AVAudioSessionPortDescription
     - Returns: The AVAudioSessionPortDescription found
     */
    open func getAudioInput(with uid: String) -> AVAudioSessionPortDescription {
        for item in availableInput() where item.uid == uid {
            return item
        }
        return defaultAudioInput()
    }

}
