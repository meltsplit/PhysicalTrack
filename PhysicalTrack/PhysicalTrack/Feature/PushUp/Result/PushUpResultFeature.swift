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
        let result: WorkoutResultFeature.State
        
        init(record: PushUpRecord) {
            self.record = record
            self.result = WorkoutResultFeature.State(grade: record.evaluate(), criterias: PushUpCriteria.toModels())
        }
    }
    
    enum Action {
        case onAppear
        case result(WorkoutResultFeature.Action)
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
            case .result:
                return .none
            }
        }
    }
}
