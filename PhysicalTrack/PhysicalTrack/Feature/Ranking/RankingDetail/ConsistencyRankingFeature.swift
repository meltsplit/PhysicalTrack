//
//  ConsistencyRankingFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ConsistencyRankingFeature {
    
    @ObservableState
    struct State {
        var ranking: [ConsistencyRankingResponse] = []
    }
    
    enum Action {
        case rankCellTapped(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            return .none
        }
    }
}
