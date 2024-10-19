//
//  RootView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<RootFeature>
    
    var body: some View {
        switch store.state {
        case .onboarding:
            if let store = store.scope(state: \.onboarding, action: \.onboarding) {
                OnboardingView(store: store)
            }
        case .main:
            if let store = store.scope(state: \.main, action: \.main) {
                MainTabView(store: store)
            }
        }
    }
}

#Preview {
    RootView(
        store: .init(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}
