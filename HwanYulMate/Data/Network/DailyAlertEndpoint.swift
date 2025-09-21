//
//  DailyAlertEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation

enum DailyAlertEndpoint: Endpoint {
    case enableDailyAlert(token: String, currencyCode: String, request: DailyAlertRequestDTO)
    case disableDailyAlert(token: String, currencyCode: String)
}

// MARK: - extensions
extension DailyAlertEndpoint {
    var baseURL: URL {
        URL(string: AppConfig.shared.baseURL)!
    }
    
    var headers: [String: String]? {
        switch self {
        case .enableDailyAlert(let token, _, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        case .disableDailyAlert(let token, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var method: HTTPMethodType {
        switch self {
        case .enableDailyAlert:
            return .post
        case .disableDailyAlert:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .enableDailyAlert(_, let currencyCode, _):
            return "/api/alert/setting/\(currencyCode)/daily"
        case .disableDailyAlert(_, let currencyCode):
            return "/api/alert/setting/\(currencyCode)/daily"
        }
    }
    
    var queryParametersEncodable: (any Encodable)? {
        nil
    }
    
    var bodyParametersEncodable: (any Encodable)? {
        switch self {
        case .enableDailyAlert(_, _, let request):
            return request
        case .disableDailyAlert:
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
