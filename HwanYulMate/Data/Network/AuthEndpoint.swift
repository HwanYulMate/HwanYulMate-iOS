//
//  AuthEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case socialLogin(request: SocialLoginRequestDTO, provider: SocialProvider)
    case sendFCMToken(request: FCMRequestDTO, accessToken: String)
}

// MARK: - extensions
extension AuthEndpoint {
    var baseURL: URL {
        URL(string: AppConfig.shared.baseURL)!
    }
    
    var headers: [String: String]? {
        switch self {
        case .socialLogin:
            return ["Content-Type": "application/json"]
        case .sendFCMToken(_, let token):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var method: HTTPMethodType {
        .post
    }
    
    var path: String {
        switch self {
        case .socialLogin(_, let provider):
            return "/api/oauth/\(provider.rawValue)"
        case .sendFCMToken:
            return "/api/fcm/token"
        }
    }
    
    var queryParametersEncodable: (any Encodable)? {
        nil
    }
    
    var bodyParametersEncodable: (any Encodable)? {
        switch self {
        case .socialLogin(let request, _):
            return request
        case .sendFCMToken(let request, _):
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
