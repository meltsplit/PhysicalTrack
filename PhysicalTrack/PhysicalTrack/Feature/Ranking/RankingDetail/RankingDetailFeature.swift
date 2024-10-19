//
//  RankingDetailFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RankingDetailFeature {
    
    @ObservableState
    struct State {
    }
    
    enum Action {
        case userCellTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            return .none
        }
    }
}
