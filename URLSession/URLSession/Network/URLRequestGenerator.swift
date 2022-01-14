//
//  URLRequestGenerator.swift
//  kakaoPayUnsplash
//
//  Created by 김효성 on 2022/01/10.
//

import Foundation

private let baseURL: String = "https://api.unsplash.com/"

protocol CoreRequest {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
}

protocol URLRequestGeneratorProtocol {
    var coreRequest: CoreRequest { get }
    func generate() -> URLRequest?
}

struct getURLRequestGenerator: URLRequestGeneratorProtocol {
    let coreRequest: CoreRequest
    
    init(coreRequest: CoreRequest) {
        self.coreRequest = coreRequest
    }
    
    func generate() -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL + coreRequest.url)
        urlComponents?.queryItems = coreRequest.parameter.map { URLQueryItem(name: $0,
                                                                             value: "\($1)") }
        guard let url = urlComponents?.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("Client-ID F-wVT68i-aoEwtEgLGNkudzcWQCAG1Q2YS2O1Hrsp5I",
                            forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json",
                            forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
