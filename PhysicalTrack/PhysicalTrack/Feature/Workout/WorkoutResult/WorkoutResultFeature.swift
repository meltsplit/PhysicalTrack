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
        var record: PushUpRecord
        var criterias = PushUp.criteriaArray
        
        init(record: PushUpRecord) {
            self.record = record
        }
    }
    
    enum Action {
        case onAppear
        case postPushUpResponse(Result<Void, Error>)
        case goStatisticsButtonTapped
    }
    
    @Dependency(\.workoutClient) var workoutClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in
                    let dto: PushUpRecordDTO = .toDTO(with: state.record)
                    let result = await Result { try await workoutClient.postPushUp(dto) }
                    await send(.postPushUpResponse(result))
                }
            case .goStatisticsButtonTapped:
                return .none
            case .postPushUpResponse(.success):
                return .none
            case .postPushUpResponse(.failure(_)):
                return .none
            }
        }
    }
}
