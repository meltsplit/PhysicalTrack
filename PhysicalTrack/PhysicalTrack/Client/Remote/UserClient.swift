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
    @Shared(.appStorage(key: .accessToken)) private static var accessToken: String = ""
    var fetchUserInfo: @Sendable () async throws -> UserInfoResponse
    var updateUserInfo: @Sendable (_ body: UserInfo) async throws -> Void
}

extension UserClient: TestDependencyKey {
    static var previewValue: Self {
        return liveValue
    }
    static var testValue: Self {
        return Self(
            fetchUserInfo: unimplemented("UserClient.fetchUserInfo"),
            updateUserInfo: unimplemented("UserClient.updateUserInfo")
        )
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
            },
            updateUserInfo: { body in
                
                let urlRequest = try URLRequest(
                    path: "/account",
                    method: .put,
                    headers: ["Authorization": accessToken],
                    body: body.toData()
                )
                
                return try await request(for: urlRequest)
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
