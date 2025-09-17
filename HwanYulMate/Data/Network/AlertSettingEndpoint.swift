//
//  AlertSettingEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation

enum AlertSettingEndpoint: Endpoint {
    case fetchAlertSetting(request: AlertSettingRequestDTO, token: String)
    case fetchAllAlertSettings(token: String)
}

// MARK: - extensions
extension AlertSettingEndpoint {
    var baseURL: URL {
        URL(string: AppConfig.shared.baseURL)!
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchAllAlertSettings(let token), .fetchAlertSetting(_, let token):
            [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var method: HTTPMethodType {
        .get
    }
    
    var path: String {
        switch self {
        case .fetchAlertSetting(let request, _):
            return "/api/alert/setting/\(request.currencyCode)"
        case .fetchAllAlertSettings:
            return "/api/alert/settings"
        }
    }
    
    var queryParametersEncodable: (any Encodable)? {
        nil
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
