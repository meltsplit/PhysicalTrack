//
//  TutorialFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/25/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TutorialFeature {
    
    enum Step: Hashable, CaseIterable {
        case first
        case second
        case third
    }
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: Step = .first
    }
    
    enum Action: Equatable {
        case tabChanged(Step)
        case confirmButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabChanged(step):
                state.selectedTab = step
                return .none
            case .confirmButtonTapped:
                return .run { _ in return await dismiss() }
            }
        }
    }
}
