//
//  MainFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {

    @ObservableState
    struct State {
        public var selectedTab: MainScene = .workout
        
        public var workout: WorkoutFeature.State? = .init()
        public var statistics: StatisticsFeature.State? = .init()
        public var ranking: RankingFeature.State? = .init()
        public var setting: SettingFeature.State? = .init()
        
        public var showTabBar: Bool = true
    }
    
    enum Action {
        
        case onAppear
        case selectTab(MainScene)
        
        case workout(WorkoutFeature.Action)
        case statistics(StatisticsFeature.Action)
        case ranking(RankingFeature.Action)
        case setting(SettingFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            return .none
        }
        .ifLet(\.workout, action: \.workout) {
            WorkoutFeature()
        }
        .ifLet(\.statistics, action: \.statistics) {
            StatisticsFeature()
        }
        .ifLet(\.ranking, action: \.ranking) {
            RankingFeature()
        }
        .ifLet(\.setting, action: \.setting) {
            SettingFeature()
        }
    }
}
