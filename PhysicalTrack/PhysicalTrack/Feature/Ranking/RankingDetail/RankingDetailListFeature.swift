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
    struct State: Equatable {
        @Shared(.selectedMainScene) var selectedScene: MainScene = .ranking
        var ranking: [RankingModel] = []
    }
    
    enum Action {
        case rankCellTapped(RankingModel)
        case workoutButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .rankCellTapped:
                return .none
            case .workoutButtonTapped:
                state.$selectedScene.withLock { $0 = .workout }
                return .run { _ in await dismiss()}
            }
            
        }
    }
}
