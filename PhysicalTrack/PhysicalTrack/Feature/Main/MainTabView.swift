//
//  MainTabView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(
                get: { $0 },
                send: MainFeature.Action.selectTab)
            ) {
                IfLetStore(
                    self.store.scope(state: \.workout, action: \.workout)
                ) { store in
                    WorkoutView(store: store)
                        .tabItem {
                            TabBarItem(.workout)
                        }
                        .tag(MainScene.workout)
                }
                
                IfLetStore(
                    self.store.scope(state: \.statistics, action: \.statistics)
                ) { store in
                    StatisticsView(store: store)
                        .tabItem {
                            TabBarItem(.statistics)
                        }
                        .tag(MainScene.statistics)
                }
                
                IfLetStore(
                    self.store.scope(state: \.ranking, action: \.ranking)
                ) { store in
                    RankingView(store: store)
                        .tabItem {
                            TabBarItem(.ranking)
                        }
                        .tag(MainScene.ranking)
                }
                
                IfLetStore(
                    self.store.scope(state: \.setting, action: \.setting)
                ) { store in
                    SettingView(store: store)
                        .tabItem {
                            TabBarItem(.setting)
                        }
                        .tag(MainScene.setting)
                }
                
                
            }
        }
    }
}

fileprivate struct TabBarItem: View {
    
    var scene: MainScene
    init(_ scene: MainScene) {
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
