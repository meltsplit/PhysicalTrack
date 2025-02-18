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
        case savePushUpRecordResponse(Result<Void, Error>)
    }
    
    @Dependency(\.workoutClient.savePushUpRecord) var savePushUpRecord
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [record = state.record] send in
                    let result = await Result { try await savePushUpRecord(record) }
                    await send(.savePushUpRecordResponse(result))
                }
            case .savePushUpRecordResponse(.success):
                return .none
            case .savePushUpRecordResponse(.failure):
                return .none

            }
        }
    }
}
