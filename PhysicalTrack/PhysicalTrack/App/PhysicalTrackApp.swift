//
//  PhysicalTrackApp.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct PhysicalTrackApp: App {
    
    static let store = Store(initialState: RootFeature.State()) {
        RootFeature()
    }

    var body: some Scene {
        WindowGroup {
            if TestContext.current == nil {
                RootView(store: Self.store)
            }
        }
        
    }
}
