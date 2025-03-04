//
//  RankingClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

enum RankingError: Error {
    case unknown
    case decodeFail
    case unauthorized
}

// MARK: - API client interface

@DependencyClient
struct RankingClient: NetworkRequestable {
    var fetchConsistency: @Sendable () async throws -> [ConsistencyRankingResponse]
    var fetchPushUp: @Sendable () async throws -> [PushUpRankingResponse]
    var fetchRunning: @Sendable () async throws -> [RunningRankingResponse]
}

// MARK: - Live API implementation

extension RankingClient: DependencyKey {
    static let liveValue = RankingClient(
        fetchConsistency: {
            @Shared(.accessToken) var accessToken = ""
            
            let urlRequest: URLRequest = try .init(
                path: "/ranking/consistency",
                method: .get,
                headers: ["Authorization": accessToken]
            )
            
            return try await request(for: urlRequest, dto: [ConsistencyRankingResponse].self).filter { $0.count > 0 }
        },
        fetchPushUp: {
            @Shared(.accessToken) var accessToken = ""
            
            let urlRequest: URLRequest = try .init(
                path: "/ranking/pushup",
                method: .get,
                headers: ["Authorization": accessToken]
            )
            
            return try await request(for: urlRequest, dto: [PushUpRankingResponse].self)
        },
        fetchRunning: {
            @Shared(.accessToken) var accessToken = ""
            
            let urlRequest: URLRequest = try .init(
                path: "/ranking/running",
                method: .get,
                headers: ["Authorization": accessToken]
            )
            
            return try await request(for: urlRequest, dto: [RunningRankingResponse].self)
        }
        
    )
}

extension DependencyValues {
    var rankingClient: RankingClient {
        get { self[RankingClient.self] }
        set { self[RankingClient.self] = newValue }
    }
}

//MARK: - Mock

extension RankingClient: TestDependencyKey {
    static let previewValue = Self(
        fetchConsistency: {
            []
        },
        fetchPushUp: {
            [.stub1]
        },
        fetchRunning: {
            []
        }
    )
    
    static let testValue = Self()
}




