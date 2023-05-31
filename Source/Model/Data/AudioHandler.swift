//
//  AudioHandler.swift
//  NapTube
//
//  Created by 0aprl1 on 16/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import AVFoundation

class AudioHandler {
    
    var recordingSession: AVAudioSession?
    var recorder: AVAudioRecorder?
    var wav_file:AVAudioFile?
    var player: AVAudioPlayer?
    var audioURL : URL?
    
}
