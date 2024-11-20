//
//  Networkable.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation
import ComposableArchitecture

enum NetworkError: Error {
    case invalidURL
    case encodeFail
    case decodeFail
    case unknown
    case unauthorized
}

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case get = "GET"
}

protocol Networkable {
    static var jsonDecoder: JSONDecoder { get }
    
    static func makeURLRequest<B: Encodable>(
        baseURL: String,
        path: String,
        method: HTTPMethod,
        headers: [String: String],
        body: B?
    ) throws -> URLRequest
    
    static func request<T: Decodable>(
        session: URLSession,
        for: URLRequest,
        dto: T.Type
    ) async throws -> T
    
    static func request(
        session: URLSession,
        for: URLRequest
    ) async throws -> Void
}


extension Networkable {
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: -9 * 24 * 60 * 60)
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
    
    static func makeURLRequest<B: Encodable>(
        baseURL: String = "http://3.36.72.104:8080/api",
        path: String,
        method: HTTPMethod,
        headers: [String: String],
        body: B?
    ) throws -> URLRequest {
        var headers = headers
        
        guard let url = URL(string: baseURL + path)
        else { throw NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
    
        if !headers.keys.contains("Content-Type") {
            headers["Content-Type"] = "application/json"
        }
        
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let body {
            guard let data = try? JSONEncoder().encode(body)
            else { throw NetworkError.encodeFail }
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
    
    static func request<T: Decodable>(
        session: URLSession = .shared,
        for urlRequest: URLRequest,
        dto: T.Type
    ) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest)
        
        let sdata = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        print(sdata ?? "Data JSONSerialization에 실패했습니다.")
        
        guard let responseBody = try? jsonDecoder.decode(DTO<T>.self, from: data)
        else { throw NetworkError.decodeFail }
        print(responseBody.message)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.unknown }
        guard httpResponse.statusCode != 401 else { throw NetworkError.unauthorized }
        guard (200...300).contains(httpResponse.statusCode) else { throw NetworkError.unknown }
        return responseBody.data
    }
    
    static func request(
        session: URLSession = .shared,
        for urlRequest: URLRequest
    ) async throws -> Void {
        let (data, response) = try await session.data(for: urlRequest)
        
        let sdata = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        print(sdata ?? "Data JSONSerialization에 실패했습니다.")
        
        guard let responseBody = try? jsonDecoder.decode(VoidDTO.self, from: data)
        else { throw NetworkError.decodeFail }
        print(responseBody.message)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.unknown }
        guard httpResponse.statusCode != 401 else { throw NetworkError.unauthorized }
        guard (200...300).contains(httpResponse.statusCode) else { throw NetworkError.unknown }
        return
    }
}
