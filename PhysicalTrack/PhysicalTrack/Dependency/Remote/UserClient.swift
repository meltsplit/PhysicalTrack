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
    var fetch: @Sendable () async throws -> UserInfo
    var update: @Sendable (_ body: UserInfo) async throws -> Void
    var withdraw: @Sendable () async throws -> Void
}

extension UserClient: TestDependencyKey {
    static var previewValue: Self {
        return Self(
            fetch: {
                .stub
            },
            update: { _ in
                _ = try await Task.sleep(for: .seconds(2))
                throw AuthError.jwtDecodeFail
            },
            withdraw: unimplemented("UserClient.withdraw")
        )
    }
    static var testValue: Self {
        return Self(
            fetch: unimplemented("UserClient.fetch"),
            update: unimplemented("UserClient.update"),
            withdraw: unimplemented("UserClient.withdraw")
        )
    }
}

extension UserClient: DependencyKey {
    static var liveValue: Self {
        Self(
            fetch: {
                @Shared(.appStorage(key: .accessToken)) var accessToken: String = ""
                let urlRequest = try URLRequest(
                    path: "/account",
                    method: .get,
                    headers: ["Authorization": accessToken]
                )
                
                return try await request(for: urlRequest, dto: UserInfoResponse.self).toDomain()
            },
            update: { body in
                @Shared(.appStorage(key: .accessToken)) var accessToken: String = ""
                let urlRequest = try URLRequest(
                    path: "/account",
                    method: .put,
                    headers: ["Authorization": accessToken],
                    body: body.toData()
                )
                
                return try await request(for: urlRequest)
            },
            withdraw: {
                @Shared(.appStorage(key: .accessToken)) var accessToken: String = ""
                let urlRequest = try URLRequest(
                    path: "/account",
                    method: .delete,
                    headers: ["Authorization": accessToken]
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
