//
//  OnboardingView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    let store : StoreOf<OnboardingFeature>
    
    var body: some View {
        Text("Onboarding")
    }
}

#Preview {
    OnboardingView(
        store: .init(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }
    )
}
