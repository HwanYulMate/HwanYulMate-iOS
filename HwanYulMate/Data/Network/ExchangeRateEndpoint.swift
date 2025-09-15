//
//  ExchangeRateEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation

enum ExchangeRateEndpoint: Endpoint {
    case fetchExchangeRate(request: ExchangeRateRequestDTO)
    case fetchAllExchangeRates
}

// MARK: - extensions
extension ExchangeRateEndpoint {
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
        switch self {
        case .fetchExchangeRate:
            return "/api/exchange/realtime"
        case .fetchAllExchangeRates:
            return "/api/exchangeList"
        }
    }
    
    var queryParametersEncodable: (any Encodable)? {
        switch self {
        case .fetchExchangeRate(let request):
            return request
        case .fetchAllExchangeRates:
            return nil
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
