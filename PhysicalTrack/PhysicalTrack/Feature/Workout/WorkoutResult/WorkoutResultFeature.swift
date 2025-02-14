//
//  TimerResultFeature.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation
import ComposableArchitecture
import Combine

@Reducer
struct WorkoutResultFeature {
    
    @ObservableState
    struct State: Equatable {
        var record: Record
        var criterias: [CriteriaModel]
        
        init(record: Record) {
            self.record = record
            self.criterias = CriteriaFactory.create(for: record).models
        }
    }
    
    enum Action {
        case onAppear
        case pushUp(PushUpRecord)
        case running(RunningRecord)
        case postPushUpResponse(Result<Void, Error>)
        case postRunningResponse(Result<Void, Error>)
        case goStatisticsButtonTapped
    }
    
    @Dependency(\.workoutClient) var workoutClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                switch state.record {
                case .pushUp(let record):
                    return .send(.pushUp(record))
                case .running(let record):
                    return .send(.running(record))
                }
               
            case .pushUp(let record):
                return .run { send in
                    let dto: PushUpRecordRequest = record.toData()
                    let result = await Result { try await workoutClient.postPushUp(dto) }
                    await send(.postPushUpResponse(result))
                }
            case .running(let record):
                return .run { send in
//                    let result = await Result { try await workoutClient.postPushUp(dto) }
//                    await send(.postPushUpResponse())
                }
            case .goStatisticsButtonTapped:
                return .none
            case .postPushUpResponse(.success), .postRunningResponse(.success):
                return .none
            case .postPushUpResponse(.failure), .postRunningResponse(.failure):
                return .none

            }
        }
    }
}
