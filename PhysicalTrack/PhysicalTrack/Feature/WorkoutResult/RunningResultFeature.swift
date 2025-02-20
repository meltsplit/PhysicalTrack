//
//  RunningResultFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/15/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RunningResultFeature {
    
    @ObservableState
    struct State: Equatable {
        let record: RunningRecord
        let criterias: [CriteriaModel]
        
        init(record: RunningRecord) {
            self.record = record
            self.criterias = RunningCriteria.toModels()
        }
    }
    
    enum Action {
        case onAppear
        case saveRunningRecordResponse(Result<Void, Error>)
    }
    
    @Dependency(\.workoutClient.saveRunningRecord) var saveRunningRecord
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [record = state.record] send in
                    let result = await Result { try await saveRunningRecord(record) }
                    await send(.saveRunningRecordResponse(result))
                }
            case .saveRunningRecordResponse(.success):
                return .none
            case .saveRunningRecordResponse(.failure):
                return .none

            }
        }
    }
}

