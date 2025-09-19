//
//  NewsEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/15/25.
//

import Foundation

enum NewsEndpoint: Endpoint {
    case fetchNews(request: NewsRequestDTO)
}

// MARK: - extensions
extension NewsEndpoint {
    var baseURL: URL {
        URL(string: AppConfig.shared.baseURL)!
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var method: HTTPMethodType {
        .get
    }
    
    var path: String {
        "/api/exchange/news/detail/paginated"
    }
    
    var queryParametersEncodable: (any Encodable)? {
        switch self {
        case .fetchNews(let request):
            return request
        }
    }
    
    var bodyParametersEncodable: (any Encodable)? {
        nil
    }
    
    var bodyEncoder: any BodyEncoder {
        JSONBodyEncoder()
    }
    
    var responseDecoder: any ResponseDecoder {
        JSONResponseDecoder()
    }
}
