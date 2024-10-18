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
    let store = Store(initialState: WorkoutFeature.State()) {
        WorkoutFeature()._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            WorkoutView(store: store)
        }
    }
}
