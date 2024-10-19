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
    struct State {
        var record: PushUpRecord
        var criterias = PushUp.criteriaArray
        
        init(record: PushUpRecord) {
            self.record = record
        }
    }
    
    enum Action {
        case onAppear
        case goStatisticsButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .goStatisticsButtonTapped:
                return .none
            }
        }
    }
}
