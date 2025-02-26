//
//  JWTDecoder.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/2/24.
//

import Foundation
import CryptoKit
import ComposableArchitecture

enum JWTDecodeError: Error {
    case invalidJWT
    case decodingError
    case headerDecodeFail
    case payloadDecodeFail
    case signatureVerificationFailed
}

struct JWTHeader: Decodable {
    let typ: String
    let alg: String
}

struct JWTPayload: Decodable {
    let deviceId: String
    let userId: Int
    let name: String
    let iat: Int
    let exp: Int
}

struct JWT: Sendable {
    let header: JWTHeader
    let payload: JWTPayload
}

@DependencyClient
struct JWTDecoder {
    var decode: @Sendable (_ jwt: String) throws -> JWT
}

extension DependencyValues {
    var jwtDecoder: JWTDecoder {
        get { self[JWTDecoder.self] }
        set { self[JWTDecoder.self] = newValue }
    }
}

extension JWTDecoder: DependencyKey {
    static let liveValue: JWTDecoder = Self(
        decode: { jwt in
            guard let jwt = jwt.components(separatedBy: " ").last
             else { throw JWTDecodeError.invalidJWT }
            
            let segments = jwt.components(separatedBy: ".")
            // JWT는 `header.payload.signature` 형식으로 되어있기 때문에 `.`로 분리합니다.
            guard segments.count == 3
            else { throw JWTDecodeError.invalidJWT }
            
            // Header와 Payload를 디코딩합니다.
            let headerData = try base64UrlDecode(segments[0])
            let payloadData = try base64UrlDecode(segments[1])
            
            // Header와 Payload를 Decodable 구조체로 변환합니다.
            guard let header = try? JSONDecoder().decode(JWTHeader.self, from: headerData) else {
                throw JWTDecodeError.headerDecodeFail
            }
            
            guard let payload = try? JSONDecoder().decode(JWTPayload.self, from: payloadData) else {
                throw JWTDecodeError.payloadDecodeFail
            }
            
            return JWT(header: header, payload: payload)
        }
    )
    
    static let previewValue: JWTDecoder = Self(
        decode: { _ in
            JWT(header: .init(typ: "", alg: ""), payload: .init(deviceId: "", userId: 1, name: "", iat: 1, exp: 1))
        }
    )
    
    static let testValue: JWTDecoder = previewValue
}

extension JWTDecoder {
    
    // Base64Url 디코딩 함수
    private static func base64UrlDecode(_ base64Url: String) throws -> Data {
        var base64 = base64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // 패딩이 필요하다면 추가합니다.
        let paddingLength = 4 - base64.count % 4
        if paddingLength < 4 {
            base64 += String(repeating: "=", count: paddingLength)
        }
        
        guard let data = Data(base64Encoded: base64) else {
            throw JWTDecodeError.decodingError
        }
        return data
    }
    
}
