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
        case postRunningResponse(Result<Void, Error>)
    }
    
    @Dependency(\.workoutClient) var workoutClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [record = state.record] send in
//                    let dto: PushUpRecordRequest = record.toData()
//                    let result = await Result { try await workoutClient.postPushUp(dto) }
//                    await send(.postPushUpResponse(result))
                }
            case .postRunningResponse(.success):
                return .none
            case .postRunningResponse(.failure):
                return .none

            }
        }
    }
}

