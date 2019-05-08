//
//  ViewController.swift
//  HPRecorderExample
//
//  Created by Hoang on 5/8/19.
//  Copyright © 2019 Quang Hoang. All rights reserved.
//

import UIKit
import HPRecorder

enum RecorderState: Int {
    case none = 0
    case recording
    case pause
    case end

    var title: String {
        switch self {
        case .none: return "Tap to record"
        case .recording: return "Tap to pause"
        case .pause: return "Tap to continue"
        case .end: return "Tap to end"

        }
    }

}
class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!

    var recorderState: RecorderState = .none
    var percent: CGFloat = 0

    var recorder: HPRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.recorder = HPRecorder()
        self.recorder.askPermission {[weak self] (grandted) in
            DispatchQueue.main.async {
                self?.recordButton.isEnabled = grandted
                if !grandted {
                    self?.recordButton.setTitle("Don't have permission", for: .normal)
                }
            }
        }
        self.recorder.percentLoudness = {[weak self] percent in
            guard let `self` = self else {return}
            let percentString = String(format: "%.2f%%", percent)
            self.percentLabel.text = percentString

            switch self.recorderState {
            case .pause, .none:
                self.percentLabel.text = "0.0%"
            default:
                ()
            }
        }

        self.recorder.recorderDidFinish = { recorder, url, success in
            print("Recorder URL \(url)")
        }

        self.recordButton.setTitle(recorderState.title, for: .normal)
        self.percentLabel.text = "0.0%"
    }

    // MARK: - IBAction
    @IBAction private func recordButtonPressed(_ sender: UIButton) {
        switch recorderState {
        case .none:
            self.recorder.startRecording()
            self.recorderState = .recording
            self.recordButton.setTitle(recorderState.title, for: .normal)
        case .recording:
            self.recorder.pauseRecording()
            self.percentLabel.text = "0.0%"
            self.recorderState = .pause
            self.recordButton.setTitle(recorderState.title, for: .normal)
        case .pause:
            self.recorder.resumeRecording()
            self.recorderState = .end
            self.recordButton.setTitle(recorderState.title, for: .normal)
        case .end:
            self.recorder.endRecording()
            self.percentLabel.text = "0.0%"
            self.recorderState = .none
            self.recordButton.setTitle(recorderState.title, for: .normal)
        }
    }

}

