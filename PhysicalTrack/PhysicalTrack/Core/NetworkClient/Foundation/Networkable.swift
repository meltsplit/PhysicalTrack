//
//  Networkable.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/19/24.
//

import Foundation

protocol NetworkRequestable {
    static var jsonDecoder: JSONDecoder { get }

    static func request<T: Decodable>(
        session: URLSession,
        for: URLRequestConvertible,
        dto: T.Type
    ) async throws -> T
    
    static func request(
        session: URLSession,
        for: URLRequestConvertible
    ) async throws -> Void
}


extension NetworkRequestable {
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: -9 * 24 * 60 * 60)
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
    
    static func request<T: Decodable>(
        session: URLSession = .shared,
        for urlRequest: URLRequestConvertible,
        dto: T.Type
    ) async throws -> T {
        let urlRequest = try urlRequest.asURLRequest()
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
        for urlRequest: URLRequestConvertible
    ) async throws -> Void {
        let urlRequest = try urlRequest.asURLRequest()
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
