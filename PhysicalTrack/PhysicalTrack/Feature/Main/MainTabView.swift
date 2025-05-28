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
            
            WorkoutView(store: store.scope(state: \.workout, action: \.workout))
                .tag(MainScene.workout)
                .tabItem { TabBarItem(.workout) }
            
            StatisticsView(store: store.scope(state: \.statistics, action: \.statistics))
                .tag(MainScene.statistics)
                .tabItem { TabBarItem(.statistics) }
            
            
            RankingView(store: store.scope(state: \.ranking, action: \.ranking))
                .tag(MainScene.ranking)
                .tabItem { TabBarItem(.ranking) }
            
            
            SettingView(store: store.scope(state: \.setting, action: \.setting))
                .tag(MainScene.setting)
                .tabItem { TabBarItem(.setting) }
            
        }
    }
}

fileprivate struct TabBarItem: View {
    
    private var scene: MainScene
    
    init(_ scene: MainScene) {
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
