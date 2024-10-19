//
//  RankingFeatrue.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RankingFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case rankingDetailButtonTapped
    }
    
    @Reducer
    enum Path {
        case rankingDetail(RankingDetailFeature)
        case statistics(StatisticsFeature)
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .rankingDetailButtonTapped:
                state.path.append(.rankingDetail(RankingDetailFeature.State()))
                return .none
            case .path(.element(id: _, action: .rankingDetail(.userCellTapped))):
                state.path.append(.statistics(StatisticsFeature.State()))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
