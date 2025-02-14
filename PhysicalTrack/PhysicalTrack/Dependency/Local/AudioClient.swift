//
//  AudioClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/22/24.
//

import Foundation
import ComposableArchitecture
import AudioToolbox

@DependencyClient
struct AudioClient {
    var play: @Sendable () -> Void
}

extension DependencyValues {
    var audioClient: AudioClient {
        get { self[AudioClient.self] }
        set { self[AudioClient.self] = newValue }
    }
}

extension AudioClient: DependencyKey {
    static var liveValue: Self = Self(
        play: {
            guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav")
            else { return }
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        })
}

extension AudioClient: TestDependencyKey {
    static var previewValue: AudioClient = liveValue
    static var testValue: AudioClient = Self(
        play: {}
    )
}
