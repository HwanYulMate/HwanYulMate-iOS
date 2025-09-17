//
//  AuthEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case socialLogin(request: SocialLoginRequestDTO, provider: SocialProvider)
}

// MARK: - extensions
extension AuthEndpoint {
    var baseURL: URL {
        URL(string: AppConfig.shared.baseURL)!
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var method: HTTPMethodType {
        .post
    }
    
    var path: String {
        switch self {
        case .socialLogin(_, let provider):
            return "/api/oauth/\(provider.rawValue)"
        }
    }
    
    var queryParametersEncodable: (any Encodable)? {
        nil
    }
    
    var bodyParametersEncodable: (any Encodable)? {
        switch self {
        case .socialLogin(let request, _):
            return request
        }
    }
    
    var bodyEncoder: any BodyEncoder {
        JSONBodyEncoder()
    }
    
    var responseDecoder: any ResponseDecoder {
        JSONResponseDecoder()
    }
}
