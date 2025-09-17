//
//  ChartEndpoint.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/14/25.
//

import Foundation

enum ChartEndpoint: Endpoint {
    case fetchWeeklyChart(request: ChartRequestDTO)
    case fetchMonthlyChart(request: ChartRequestDTO)
    case fetchThreeMonthsChart(request: ChartRequestDTO)
    case fetchSixMonthsChart(request: ChartRequestDTO)
    case fetchYearlyChart(request: ChartRequestDTO)
}

// MARK: - extensions
extension ChartEndpoint {
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
        case .fetchWeeklyChart:
            return "/api/exchange/weekly"
        case .fetchMonthlyChart:
            return "/api/exchange/monthly"
        case .fetchThreeMonthsChart:
            return "/api/exchange/3months"
        case .fetchSixMonthsChart:
            return "/api/exchange/6months"
        case .fetchYearlyChart:
            return "/api/exchange/yearly"
        }
    }
    
    var queryParametersEncodable: (any Encodable)? {
        switch self {
        case .fetchWeeklyChart(let request):
            return request
        case .fetchMonthlyChart(let request):
            return request
        case .fetchThreeMonthsChart(let request):
            return request
        case .fetchSixMonthsChart(let request):
            return request
        case .fetchYearlyChart(let request):
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
