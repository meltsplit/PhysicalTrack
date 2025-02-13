//
//  PhysicalTrackApp.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture
import CoreLocation

@main
struct PhysicalTrackApp: App {
    let store = Store(initialState: RootFeature.State()) {
        RootFeature()
    }

    var body: some Scene {
        WindowGroup {
            if TestContext.current == nil {
                RootView(store: store)
            }
        }
        
    }
}
