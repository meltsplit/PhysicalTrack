//
//  StatisticsFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StatisticsFeature {
    
    @ObservableState
    struct State {
        var a = ""
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            return .none
        }
    }
}
