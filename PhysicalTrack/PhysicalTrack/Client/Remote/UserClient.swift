//
//  UserClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct UserClient: NetworkRequestable {
    @Shared(.appStorage(key: .accessToken)) static var accessToken: String = ""
    var fetchUserInfo: @Sendable () async throws -> UserInfoResponse
}

extension UserClient: TestDependencyKey {
    static var previewValue: Self {
        return liveValue
    }
    static var testValue: Self {
        return Self(fetchUserInfo: unimplemented())
    }
}

extension UserClient: DependencyKey {
    static var liveValue: Self {
        Self(
            fetchUserInfo: {
                
                let urlRequest = try URLRequest(
                    path: "/account",
                    method: .get,
                    headers: ["Authorization": accessToken]
                )
                
                return try await request(for: urlRequest, dto: UserInfoResponse.self)
            }
        )
    }
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
