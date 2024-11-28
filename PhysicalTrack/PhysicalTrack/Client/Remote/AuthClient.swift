//
//  AuthClient.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/2/24.
//

import Foundation
import ComposableArchitecture

enum AuthError: Error {
    case unknown
    case jwtDecodeFail
    case unauthorized
}
// MARK: - API client interface

@DependencyClient
struct AuthClient: NetworkRequestable {
    var signUp: @Sendable (_ request: SignUpRequest) async throws -> String
    var signIn: @Sendable (_ request: SignInRequest) async throws -> String
}

// MARK: - Live API implementation

extension AuthClient: DependencyKey {
    static let liveValue = AuthClient(
        signUp: { request in
            let url = URL(string: "http://3.36.72.104:8080/api/user/sign-up")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = try JSONEncoder().encode(request)
            urlRequest.httpBody = body
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let responseBody = try? jsonDecoder.decode(VoidDTO.self, from: data)
            else { throw AuthError.unknown }
            print(responseBody)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw AuthError.unknown }
            guard (200...300).contains(httpResponse.statusCode) else { throw AuthError.unauthorized }
            
            guard let jwtString = httpResponse.allHeaderFields["Authorization"] as? String
            else { throw AuthError.jwtDecodeFail }
            
            return jwtString
            
        }, signIn: { request in
            let url = URL(string: "http://3.36.72.104:8080/api/user/sign-in")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            let encodedBody = try JSONEncoder().encode(request)
            urlRequest.httpBody = encodedBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let responseBody = try? jsonDecoder.decode(VoidDTO.self, from: data)
            else { throw AuthError.unknown }
            print(responseBody)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw AuthError.unknown }
            guard (200...300).contains(httpResponse.statusCode) else { throw AuthError.unauthorized }
            
            guard let jwtString = httpResponse.allHeaderFields["Authorization"] as? String
            else { throw AuthError.jwtDecodeFail }
            
            return jwtString
        }
    )
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

//MARK: - Mock

extension AuthClient: TestDependencyKey {
    static let previewValue = Self(
        signUp: { _ in "" },
        signIn: { _ in "" }
    )
    
    static let testValue = Self()
}




