//
//  WorkoutClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/20/24.
//

import Foundation
import ComposableArchitecture
import Combine

struct WorkoutClient: Networkable {
    var postPushUp: @Sendable (_ request: PushUpRecordDTO) async throws -> Void

}

extension DependencyValues {
    var workoutClient: WorkoutClient {
        get { self[WorkoutClient.self] }
        set { self[WorkoutClient.self] = newValue}
    }
}

extension WorkoutClient {
    static let previewValue: WorkoutClient = Self(
        postPushUp: { _ in return }
    )
    
    static let testValue: WorkoutClient = previewValue
}

extension WorkoutClient: DependencyKey {
    
    static let liveValue: WorkoutClient = Self(
        postPushUp: { dto in
            @Shared(.appStorage(key: .accessToken)) var accessToken = ""
            guard !accessToken.isEmpty else { throw NetworkError.unauthorized }
            
            let urlRequest = try makeURLRequest(
                path: "/record/pushup",
                method: .post,
                headers: ["Authorization": accessToken],
                body: dto)
            
            return try await request(for: urlRequest)
        }
    )
}
