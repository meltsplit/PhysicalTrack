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
}

// MARK: - Live API implementation

extension RankingClient: DependencyKey {
    static let liveValue = RankingClient(
        fetchConsistency: {
            
            @Shared(.appStorage(key: .accessToken)) var accessToken = ""
            guard !accessToken.isEmpty else { throw NetworkError.unauthorized }
            
            let urlRequest: URLRequest = try .init(
                path: "/ranking/consistency",
                method: .get,
                headers: ["Authorization": accessToken]
            )
            
            return try await request(for: urlRequest, dto: [ConsistencyRankingResponse].self).filter { $0.value > 0}
        },
        fetchPushUp: {
            
            @Shared(.appStorage(key: .accessToken)) var accessToken = ""
            guard !accessToken.isEmpty else { throw NetworkError.unauthorized }
            
            let urlRequest: URLRequest = try .init(
                path: "/ranking/pushup",
                method: .get,
                headers: ["Authorization": accessToken]
            )
            
            return try await request(for: urlRequest, dto: [PushUpRankingResponse].self)
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
        }
    )
    
    static let testValue = Self()
}




