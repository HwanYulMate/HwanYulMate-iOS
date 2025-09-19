//
//  ExchangeRateResponseDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation

struct ExchangeRateResponseDTO: Decodable {
    let currencyCode: String
    let currencyName: String
    let flagImageUrl: String
    let exchangeRate: Double
    let baseDate: String
    let changeAmount: Double
    let changePercent: Double
    let changeDirection: TrendResponse
    
    enum CodingKeys: String, CodingKey {
        case currencyCode = "currency_code"
        case currencyName = "currency_name"
        case flagImageUrl = "flag_image_url"
        case exchangeRate = "exchange_rate"
        case baseDate = "base_date"
        case changeAmount = "change_amount"
        case changePercent = "change_percent"
        case changeDirection = "change_direction"
    }
    
    enum TrendResponse: String, Decodable {
        case up = "UP"
        case down = "DOWN"
        case stable = "STABLE"
    }
}

// MARK: - extensions
extension ExchangeRateResponseDTO {
    func toEntity() -> ExchangeRate {
        return .init(
            currencyCode: currencyCode,
            currencyName: currencyName,
            flagImageUrl: flagImageUrl,
            exchangeRate: exchangeRate,
            baseDate: baseDate,
            changeAmount: changeAmount,
            changePercent: changePercent,
            changeDirection: changeDirection.toEntity()
        )
    }
}

extension ExchangeRateResponseDTO.TrendResponse {
    func toEntity() -> ExchangeRate.Trend {
        switch self {
        case .up:
            return .up
        case .down:
            return .down
        case .stable:
            return .stable
        }
    }
}
