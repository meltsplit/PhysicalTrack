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
        SwitchStore(self.store) { state in
            switch state {
            case .onboarding:
                CaseLet(
                    \RootFeature.State.onboarding,
                     action: RootFeature.Action.onboarding
                ) { store in
                    OnboardingView(store: store)
                }
            case .main:
                CaseLet(
                    \RootFeature.State.main,
                     action: RootFeature.Action.main
                ) { store in
                    MainTabView(store: store)
                }
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
