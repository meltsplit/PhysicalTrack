//
//  JWTDecoder.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/2/24.
//

import Foundation
import CryptoKit

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

struct JWT {
    let header: JWTHeader
    let payload: JWTPayload
}

struct JWTDecoder {
    static func decode(_ jwt: String) throws -> JWT {
        // JWT는 `header.payload.signature` 형식으로 되어있기 때문에 `.`로 분리합니다.
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else {
            throw JWTDecodeError.invalidJWT
        }
        
        // Header와 Payload를 디코딩합니다.
        let headerData = try base64UrlDecode(String(segments[0]))
        let payloadData = try base64UrlDecode(String(segments[1]))
        
        // Header와 Payload를 Decodable 구조체로 변환합니다.
        guard let header = try? JSONDecoder().decode(JWTHeader.self, from: headerData) else {
            throw JWTDecodeError.headerDecodeFail
        }
        
        guard let payload = try? JSONDecoder().decode(JWTPayload.self, from: payloadData) else {
            throw JWTDecodeError.payloadDecodeFail
        }

        return JWT(header: header, payload: payload)
    }
    
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
