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
            if let store = store.scope(state: \.workout, action: \.workout) {
                WorkoutView(store: store)
                    .tag(MainScene.workout)
                    .tabItem { TabBarItem(.workout) }
            }
            
            if let store = store.scope(state: \.statistics, action: \.statistics) {
                StatisticsView(store: store)
                    .tag(MainScene.statistics)
                    .tabItem { TabBarItem(.statistics) }
            }
            
            if let store = store.scope(state: \.ranking, action: \.ranking) {
                RankingView(store: store)
                    .tag(MainScene.ranking)
                    .tabItem { TabBarItem(.ranking) }
            }
            
            if let store = store.scope(state: \.setting, action: \.setting) {
                SettingView(store: store)
                    .tag(MainScene.setting)
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
        Label(scene.title, systemImage:  scene.systemImage)
    }
}


#Preview {
    RootView(
        store: .init(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}
