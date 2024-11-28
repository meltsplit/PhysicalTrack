//
//  HapticClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/20/24.
//

import UIKit
import ComposableArchitecture

@DependencyClient
struct HapticClient {
    let impact: @Sendable (UIImpactFeedbackGenerator.FeedbackStyle) -> Void
}

extension HapticClient: TestDependencyKey {
    static let previewValue = Self(
        impact: { style in
            Task { @MainActor in
                UIImpactFeedbackGenerator(style: style).impactOccurred()
            }
            
        }
    )
    
    static let testValue = previewValue
}

extension DependencyValues {
    var hapticClient: HapticClient {
        get { self[HapticClient.self] }
        set { self[HapticClient.self] = newValue }
    }
}

extension HapticClient: DependencyKey {
    static let liveValue: Self = {
        return .init(
            impact: { style in
                Task { @MainActor in
                    UIImpactFeedbackGenerator(style: style).impactOccurred()
                }
            })
    }()
}

