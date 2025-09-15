//
//  BankEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

enum BankEndpoint: Endpoint {
    case fetchAllBankExchangeInfos(request: BankRequestDTO)
}

// MARK: - extensions
extension BankEndpoint {
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
        "/api/exchange/calculate"
    }
    
    var queryParametersEncodable: (any Encodable)? {
        switch self {
        case .fetchAllBankExchangeInfos(let request):
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
