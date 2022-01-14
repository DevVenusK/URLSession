//
//  API.swift
//  kakaoPayUnsplash
//
//  Created by 김효성 on 2022/01/10.
//

import Foundation

enum HTTPMethod: String {
    case get
}

protocol APIProtocol {
    func API<T: Codable>(_ coreRequest: URLRequestGeneratorProtocol,
                                responseType: T.Type) async throws -> T?
}

struct API: APIProtocol {
    private enum APIError: Error {
        case Request
        case Response
        case StatusCode(Int)
        case isDataEmpty
    }
    
    struct Request { }
    struct Response { }
}

extension API {
    func API<T: Codable>(_ URLRequestGenerator: URLRequestGeneratorProtocol,
                                responseType: T.Type) async throws -> T? {
        let request: URLRequest? = URLRequestGenerator.generate()
                
        guard let request = request else { throw APIError.Request }
        let (data, response) = try await URLSession.shared.data(from: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw APIError.Response }
        guard statusCode == 200 else { throw APIError.StatusCode(statusCode) }
        guard !data.isEmpty else { throw APIError.isDataEmpty }
        
        let decoder = try JSONDecoder().decode(T.self, from: data)
        return decoder
    }
}
