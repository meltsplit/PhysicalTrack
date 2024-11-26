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
        var selectedTab: MainScene
        
        var workout: WorkoutFeature.State? = .init()
        var statistics: StatisticsFeature.State? = .init()
        var ranking: RankingFeature.State? = .init()
        var setting: SettingFeature.State? = .init()
        
        init(_ selectedTab: MainScene = .workout) {
            self.selectedTab = selectedTab
        }
    }
    
    enum Action {
        case selectTab(MainScene)
        
        case workout(WorkoutFeature.Action)
        case statistics(StatisticsFeature.Action)
        case ranking(RankingFeature.Action)
        case setting(SettingFeature.Action)
    }
    
    
    @Dependency(\.hapticClient) var hapticClient
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case let .selectTab(newValue):
                hapticClient.impact(.light)
                state.selectedTab = newValue
                return .none
            case .workout(.timer(.presented(.path(.element(id: _, action: .goStatisticsButtonTapped))))):
                hapticClient.impact(.light)
                state.selectedTab = .statistics
                return .none
                
            case .ranking(.workoutButtonTapped),
                    .ranking(.path(.element(id: _, action: .rankingDetail(.consistency(.workoutButtonTapped))))),
                    .ranking(.path(.element(id: _, action: .rankingDetail(.pushUp(.workoutButtonTapped))))):
                hapticClient.impact(.light)
                state.selectedTab = .workout
                return .none
            default:
                return .none
            }
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
