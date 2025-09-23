//
//  BankResponseDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

struct BankResponseDTO: Decodable {
    let bankName: String
    let bankCode: String
    let baseRate: Double
    let appliedRate: Double
    let preferentialRate: Double
    let spreadRate: Double
    let totalFee: Double
    let feeDetail: FeeDetailResponseDTO
    let finalAmount: Double
    let inputAmount: Double
    let currencyCode: String
    let flagImageUrl: String
    let isOnlineAvailable: Bool
    let description: String
    let baseDate: String
}

// MARK: - extensions
extension BankResponseDTO {
    struct FeeDetailResponseDTO: Decodable {
        let fixedFee: Double
        let feeRate: Double
        let rateBasedFee: Double
    }
}

extension BankResponseDTO {
    func toEntity() -> Bank {
        return .init(
            bankName: bankName,
            bankCode: bankCode,
            baseRate: baseRate,
            appliedRate: appliedRate,
            preferentialRate: preferentialRate,
            spreadRate: spreadRate,
            totalFee: totalFee,
            feeDetail: feeDetail.toEntity(),
            finalAmount: finalAmount,
            inputAmount: inputAmount,
            currencyCode: currencyCode,
            flagImageUrl: flagImageUrl,
            isOnlineAvailable: isOnlineAvailable,
            description: description,
            baseDate: baseDate
        )
    }
}

extension BankResponseDTO.FeeDetailResponseDTO {
    func toEntity() -> FeeDetail {
        return .init(
            fixedFee: fixedFee,
            feeRate: feeRate,
            rateBasedFee: rateBasedFee
        )
    }
}
