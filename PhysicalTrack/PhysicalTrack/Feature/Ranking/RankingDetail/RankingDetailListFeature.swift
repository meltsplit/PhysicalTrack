//
//  RankingDetailListFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RankingDetailListFeature {
    
    @ObservableState
    struct State {
        var ranking: [any RankingRepresentable] = []
    }
    
    enum Action {
        case rankCellTapped(any RankingRepresentable)
        case workoutButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .rankCellTapped:
                return .none
            case .workoutButtonTapped:
                return .run { _ in await dismiss()}
            }
            
        }
    }
}
