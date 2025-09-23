//
//  Bank.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

struct Bank {
    let bankName: String
    let bankCode: String
    let baseRate: Double
    let appliedRate: Double
    let preferentialRate: Double
    let spreadRate: Double
    let totalFee: Double
    let feeDetail: FeeDetail
    let finalAmount: Double
    let inputAmount: Double
    let currencyCode: String
    let flagImageUrl: String
    let isOnlineAvailable: Bool
    let description: String
    let baseDate: String
}

struct FeeDetail {
    let fixedFee: Double
    let feeRate: Double
    let rateBasedFee: Double
}
