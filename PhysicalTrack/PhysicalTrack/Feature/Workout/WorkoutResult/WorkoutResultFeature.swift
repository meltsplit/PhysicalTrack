//
//  TimerResultFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WorkoutResultFeature {
    
    @ObservableState
    struct State: Equatable {
        var count: Int
        
        init(count: Int) {
            self.count = count
        }
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            
            }
        }
    }
}
