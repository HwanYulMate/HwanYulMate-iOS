//
//  TargetPriceResponseDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation

struct TargetPriceResponseDTO: Decodable {
    let success: Bool
    let message: String
    let currencyCode: String
    let alertType: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case currencyCode = "currency_code"
        case alertType = "alert_type"
        case status = "status"
    }
}

// MARK: - extensions
extension TargetPriceResponseDTO {
    func toEntity() -> TargetPrice {
        return .init(
            success: success,
            message: message,
            currencyCode: currencyCode,
            alertType: alertType,
            status: status
        )
    }
}
