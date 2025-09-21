//
//  TargetPriceEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation

enum TargetPriceEndpoint: Endpoint {
    case enableTargetPriceAlert(token: String, currencyCode: String, request: TargetPriceRequestDTO)
    case disableTargetPriceAlert(token: String, currencyCode: String)
}

// MARK: - extensions
extension TargetPriceEndpoint {
    var baseURL: URL {
        URL(string: AppConfig.shared.baseURL)!
    }
    
    var headers: [String: String]? {
        switch self {
        case .enableTargetPriceAlert(let token, _, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        case .disableTargetPriceAlert(let token, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var method: HTTPMethodType {
        switch self {
        case .enableTargetPriceAlert:
            return .post
        case .disableTargetPriceAlert:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .enableTargetPriceAlert(_, let currencyCode, _):
            return "/api/alert/setting/\(currencyCode)/target"
        case .disableTargetPriceAlert(_, let currencyCode):
            return "/api/alert/setting/\(currencyCode)/target"
        }
    }
    
    var queryParametersEncodable: (any Encodable)? {
        nil
    }
    
    var bodyParametersEncodable: (any Encodable)? {
        switch self {
        case .enableTargetPriceAlert(_, _, let request):
            return request
        case .disableTargetPriceAlert:
            return nil
        }
    }
    
    var bodyEncoder: any BodyEncoder {
        JSONBodyEncoder()
    }
    
    var responseDecoder: any ResponseDecoder {
        JSONResponseDecoder()
    }
}
