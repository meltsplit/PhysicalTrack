//
//  WorkoutClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/20/24.
//

import Foundation
import ComposableArchitecture
import Combine

struct WorkoutClient: NetworkRequestable {
    var postPushUp: @Sendable (_ request: PushUpRecordRequest) async throws -> Void
}

extension DependencyValues {
    var workoutClient: WorkoutClient {
        get { self[WorkoutClient.self] }
        set { self[WorkoutClient.self] = newValue}
    }
}

extension WorkoutClient: DependencyKey {
    
    static let liveValue: WorkoutClient = Self(
        postPushUp: { dto in
            @Shared(.appStorage(key: .accessToken)) var accessToken = ""
            
            let urlRequest: URLRequest = try .init(
                path: "/record/pushup",
                method: .post,
                headers: ["Authorization": accessToken],
                body: dto
            )
            
            return try await request(for: urlRequest)
        }
    )
}

extension WorkoutClient {
    static let previewValue: WorkoutClient = Self(
        postPushUp: { _ in return }
    )
    
    static let testValue: WorkoutClient = previewValue
}
