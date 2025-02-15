//
//  TimerResultFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture
import Combine

@Reducer
struct WorkoutResultFeature {
    
    @ObservableState
    enum State: Equatable {
        case pushUp(PushUpResultFeature.State)
        case running(RunningResultFeature.State)
        
        var grade: Grade {
            switch self {
            case .pushUp(let state): return state.record.evaluate()
            case .running(let state): return state.record.evaluate()
            }
        }
        
        var criterias: [CriteriaModel] {
            switch self {
            case .pushUp(let state): return state.criterias
            case .running(let state): return state.criterias
            }
        }
    }
    
    enum Action {
        case onAppear
        case pushUp(PushUpResultFeature.Action)
        case running(RunningResultFeature.Action)
        case goStatisticsButtonTapped
    }
    
    @Dependency(\.workoutClient) var workoutClient
    @Shared(.selectedMainScene) var selectedTab: MainScene = .workout
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .pushUp:
                return .none
            case .running:
                return .none
            case .goStatisticsButtonTapped:
                $selectedTab.withLock { $0 = .statistics }
                return .none
            }
        }
    }
}
