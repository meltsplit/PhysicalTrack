//
//  URLRequestConvertible.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/20/24.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    var urlRequest: URLRequest? { try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest { self }
}


extension URLRequest {
    
    init<B: Encodable>(
        baseURL: String = "https://physical-track.site/api",
        path: String,
        method: HTTPMethod,
        headers: [String: String],
        body: B
    ) throws {
        var headers = headers
        
        guard let url = URL(string: baseURL + path)
        else { throw NetworkError.invalidURL }
        self.init(url: url)

        httpMethod = method.rawValue
    
        if !headers.keys.contains("Content-Type") {
            headers["Content-Type"] = "application/json"
        }
        
        for header in headers {
            addValue(header.value, forHTTPHeaderField: header.key)
        }

        guard let data = try? JSONEncoder().encode(body)
        else { throw NetworkError.encodeFail }
        httpBody = data
    }
    
    init(
        baseURL: String = "https://physical-track.site/api",
        path: String,
        method: HTTPMethod,
        headers: [String: String]
    ) throws {
        var headers = headers
        
        guard let url = URL(string: baseURL + path)
        else { throw NetworkError.invalidURL }
        self.init(url: url)

        httpMethod = method.rawValue
    
        if !headers.keys.contains("Content-Type") {
            headers["Content-Type"] = "application/json"
        }
        
        for header in headers {
            addValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}
