//
//  VoiceReaderService.swift
//  Hidden Fee App
//

import Foundation
import AVFoundation

@Observable
final class VoiceReaderService {
    var isEnabled: Bool = false {
        didSet {
            if !isEnabled {
                synthesizer.stopSpeaking(at: .immediate)
            }
        }
    }

    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        guard isEnabled else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.52
        utterance.volume = 1.0
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
