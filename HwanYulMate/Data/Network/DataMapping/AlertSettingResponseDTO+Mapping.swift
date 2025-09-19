//
//  AlertSettingResponseDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation

struct AlertSettingResponseDTO: Decodable {
    let currencyCode: String
    let currencyName: String
    let flagImageUrl: String
    let isTargetPriceEnabled: Bool
    let isDailyAlertEnabled: Bool
    let targetPrice: Double?
    let targetPricePushHow: String?
    let dailyAlertTime: String?
    
    enum CodingKeys: String, CodingKey {
        case currencyCode = "currency_code"
        case currencyName = "currency_name"
        case flagImageUrl = "flag_image_url"
        case isTargetPriceEnabled = "is_target_price_enabled"
        case isDailyAlertEnabled = "is_daily_alert_enabled"
        case targetPrice = "target_price"
        case targetPricePushHow = "target_price_push_how"
        case dailyAlertTime = "daily_alert_time"
    }
}

// MARK: - extensions
extension AlertSettingResponseDTO {
    func toEntity() -> AlertSetting {
        return .init(
            currencyCode: currencyCode,
            currencyName: currencyName,
            flagImageUrl: flagImageUrl,
            isTargetPriceEnabled: isTargetPriceEnabled,
            isDailyAlertEnabled: isDailyAlertEnabled,
            targetPrice: targetPrice,
            targetPricePushHow: targetPricePushHow,
            dailyAlertTime: dailyAlertTime
        )
    }
}
