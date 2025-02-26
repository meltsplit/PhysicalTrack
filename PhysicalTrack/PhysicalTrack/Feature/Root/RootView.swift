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
        Group {
            switch store.selectedScene {
            case .splash:
                splashView
                    .onAppear {
                        store.send(.onAppear)
                    }
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
    
    var splashView: some View {
        VStack(spacing: 18) {
            Spacer()
                .frame(height: 200)
            
            GIFView(gifName: "pushup")
                .frame(width: 250, height: 80)
            
            Text("피지컬 트랙")
                .font(.largeTitle.bold())
            
            Text("국군 장병을 위한\n체력 검정 루틴 관리 앱")
                .font(.title3.bold())
                .foregroundStyle(.ptGray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.ptBackground)
    }
    
    
}

#Preview {
    RootView(
        store: .init(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}
