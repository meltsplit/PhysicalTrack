//
//  RankingClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

// MARK: - API client interface

@DependencyClient
struct RankingClient: Networkable {
    var fetch: @Sendable () async throws -> DTO<RankingResponse>
}

// MARK: - Live API implementation

extension RankingClient: DependencyKey {
    static let liveValue = RankingClient(
        fetch: {
            var url = URL(string: "https://baseURL/api/statistics/stats")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try jsonDecoder.decode(DTO<RankingResponse>.self, from: data)
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
        fetch: { .success(.mock) }
    )
    
    static let testValue = Self()
}




