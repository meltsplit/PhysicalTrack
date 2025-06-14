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
        var grade: Grade
        var criterias: [CriteriaModel]
        
        init(grade: Grade, criterias: [CriteriaModel]) {
            self.grade = grade
            self.criterias = criterias
        }
    }
    
    enum Action {
        case onAppear
        case goStatisticsButtonTapped
    }
    
    @Dependency(\.workoutClient) var workoutClient
    
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
