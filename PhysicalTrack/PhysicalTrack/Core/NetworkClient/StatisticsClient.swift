//
//  StatisticsClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture


// MARK: - API client interface

@DependencyClient
struct StatisticsClient: Networkable {
    var fetchMy: @Sendable () async throws -> DTO<StatisticsResponse>
    var fetchOther: @Sendable (_ userID: Int) async throws -> DTO<StatisticsResponse>
}

// MARK: - Live API implementation

extension StatisticsClient: DependencyKey {
    static let liveValue = StatisticsClient(
        fetchMy: {
            var url = URL(string: "https://baseURL/api/statistics/stats")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try jsonDecoder.decode(DTO<StatisticsResponse>.self, from: data)
        },
        fetchOther: { query in
            var url = URL(string: "https://baseURL/api/statistics/stats")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try jsonDecoder.decode(DTO<StatisticsResponse>.self, from: data)
        }
    )
}

extension DependencyValues {
    var statisticsClient: StatisticsClient {
        get { self[StatisticsClient.self] }
        set { self[StatisticsClient.self] = newValue }
    }
}

//MARK: - Mock

extension StatisticsClient: TestDependencyKey {
    static let previewValue = Self(
        fetchMy: { .success(.mock) },
        fetchOther: { _ in .fail(.mock) }
    )
    
    static let testValue = Self()
}




