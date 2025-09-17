//
//  ExchangeRate.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation

struct ExchangeRate {
    let currencyCode: String
    let currencyName: String
    let flagImageUrl: String
    let exchangeRate: Double
    let baseDate: String
    let changeAmount: Double
    let changePercent: Double
    let changeDirection: Trend
    
    enum Trend {
        case up
        case down
        case stable
    }
}
