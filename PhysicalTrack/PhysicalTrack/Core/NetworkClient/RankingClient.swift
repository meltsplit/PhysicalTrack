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
struct RankingClient: Networkable {
    var fetchConsistency: @Sendable (_ accessToken: String) async throws -> [ConsistencyRankingResponse]
    var fetchPushUp: @Sendable (_ accessToken: String) async throws -> [PushUpRankingResponse]
}

// MARK: - Live API implementation

extension RankingClient: DependencyKey {
    static let liveValue = RankingClient(
        fetchConsistency: { accessToken in
            let url = URL(string: "http://3.36.72.104:8080/api/ranking/consistency")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            let sdata = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(sdata)
            guard let responseBody = try? jsonDecoder.decode(DTO<ConsistencyResponse>.self, from: data)
            else { throw RankingError.decodeFail }
            
            print(responseBody)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw RankingError.unknown }
            guard httpResponse.statusCode != 401 else { throw RankingError.unauthorized }
            guard (200...300).contains(httpResponse.statusCode) else { throw RankingError.unknown }
            
            return responseBody.data.consistencyRanking
        },
        fetchPushUp: { accessToken in
            let url = URL(string: "http://3.36.72.104:8080/api/ranking/pushup")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let sdata = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(sdata)
            guard let responseBody = try? jsonDecoder.decode(DTO<PushUpResponse>.self, from: data)
            else { throw RankingError.decodeFail }
            print("🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏")
            print(responseBody)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw RankingError.unknown }
            guard httpResponse.statusCode != 401 else { throw RankingError.unauthorized }
            guard (200...300).contains(httpResponse.statusCode) else { throw RankingError.unknown }
            
            return responseBody.data.pushupRanking
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
        fetchConsistency: { _ in
            [.stub1]
        },
        fetchPushUp: { _ in
            [.stub1]
        }
    )
    
    static let testValue = Self()
}




