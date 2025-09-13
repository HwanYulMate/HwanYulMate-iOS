//
//  ExchangeRateEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation

enum ExchangeRateEndpoint: Endpoint {
    case fetchAllExchangeRates
}

// MARK: - extensions
extension ExchangeRateEndpoint {
    typealias Response = [ExchangeRateResponseDTO]
    
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
        "/api/exchangeList"
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
