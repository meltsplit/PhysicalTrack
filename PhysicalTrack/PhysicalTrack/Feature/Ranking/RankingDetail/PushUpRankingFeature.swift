//
//  PushUpRankingFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PushUpRankingFeature {
    
    @ObservableState
    struct State {
        var ranking: [PushUpRankingResponse] = []
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
