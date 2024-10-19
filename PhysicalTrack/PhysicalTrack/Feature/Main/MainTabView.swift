//
//  MainTabView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    @Bindable var store: StoreOf<MainFeature>
    
    var body: some View {
        TabView(
            selection: $store.selectedTab.sending(\.selectTab)
        ) {
            
            if let store = store.scope(
                state: \.workout,
                action: \.workout
            ) {
                WorkoutView(store: store)
                    .tabItem { TabBarItem(.workout) }
            }
            
            if let store = store.scope(
                state: \.statistics,
                action: \.statistics
            ) {
                StatisticsView(store: store)
                    .tabItem { TabBarItem(.statistics) }
            }
            
            if let store = store.scope(
                state: \.ranking,
                action: \.ranking
            ) {
                RankingView(store: store)
                    .tabItem { TabBarItem(.ranking) }
            }
            
            if let store = store.scope(
                state: \.setting,
                action: \.setting
            ) {
                SettingView(store: store)
                    .tabItem { TabBarItem(.setting) }
            }
        }
    }
}

fileprivate struct TabBarItem: View {
    
    private var scene: MainScene
    
    fileprivate init(_ scene: MainScene) {
        self.scene = scene
    }
    
    var body: some View {
        Label(scene.title, systemImage:  scene.image)
    }
}


#Preview {
    RootView(
        store: .init(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}
