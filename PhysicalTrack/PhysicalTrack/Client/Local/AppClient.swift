//
//  AppClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/2/24.
//

import UIKit
import ComposableArchitecture

@DependencyClient
struct AppClient {
    let deviceID: @Sendable () async -> String
}

extension AppClient: TestDependencyKey {
    static let previewValue = Self(
        deviceID: {
            return "preview_deviceID"
        }
    )
    
    static let testValue = previewValue
}

extension DependencyValues {
    var appClient: AppClient {
        get { self[AppClient.self] }
        set { self[AppClient.self] = newValue }
    }
}

extension AppClient: DependencyKey {
    static let liveValue: Self = .init(
        deviceID: {
            await MainActor.run {
                UIDevice.current.identifierForVendor?.uuidString ?? "unknown-device"
                
            }
        }
    )
        
}

