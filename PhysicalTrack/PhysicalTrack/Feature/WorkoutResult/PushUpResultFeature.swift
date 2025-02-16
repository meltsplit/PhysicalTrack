//
//  PushUpResultFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/15/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PushUpResultFeature {
    
    @ObservableState
    struct State: Equatable {
        let record: PushUpRecord
        let criterias: [CriteriaModel]
        
        init(record: PushUpRecord) {
            self.record = record
            self.criterias = PushUpCriteria.toModels()
        }
    }
    
    enum Action {
        case onAppear
        case postPushUpResponse(Result<Void, Error>)
    }
    
    @Dependency(\.workoutClient) var workoutClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [record = state.record] send in
                    let dto: PushUpRecordRequest = record.toData()
                    let result = await Result { try await workoutClient.postPushUp(dto) }
                    await send(.postPushUpResponse(result))
                }
            case .postPushUpResponse(.success):
                return .none
            case .postPushUpResponse(.failure):
                return .none

            }
        }
    }
}
