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
    var savePushUpRecord: @Sendable (_ record: PushUpRecord) async throws -> Void
    var saveRunningRecord: @Sendable (_ record: RunningRecord) async throws -> Void
}

extension DependencyValues {
    var workoutClient: WorkoutClient {
        get { self[WorkoutClient.self] }
        set { self[WorkoutClient.self] = newValue}
    }
}

extension WorkoutClient: DependencyKey {
    
    static let liveValue: WorkoutClient = Self(
        savePushUpRecord: { record in
            @Shared(.accessToken) var accessToken = ""
            let requestBody = record.toData()
            let urlRequest: URLRequest = try .init(
                path: "/record/pushup",
                method: .post,
                headers: ["Authorization": accessToken],
                body: requestBody
            )
            return try await request(for: urlRequest)
        },
        saveRunningRecord: { record in
            @Shared(.accessToken) var accessToken = ""
            let requestBody = record.toData()
            let urlRequest = try URLRequest(
                path: "/record/running",
                method: .post,
                headers: ["Authorization": accessToken],
                body: requestBody
            )
            return try await request(for: urlRequest)
        }
    )
}

extension WorkoutClient {
    static let previewValue: WorkoutClient = Self(
        savePushUpRecord: { _ in return },
        saveRunningRecord: { _ in return }
    )
    
    static let testValue: WorkoutClient = previewValue
}
