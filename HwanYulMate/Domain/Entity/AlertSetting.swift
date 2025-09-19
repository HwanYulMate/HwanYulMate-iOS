//
//  AlertSetting.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation

struct AlertSetting {
    let currencyCode: String
    let currencyName: String
    let flagImageUrl: String
    let isTargetPriceEnabled: Bool
    let isDailyAlertEnabled: Bool
    let targetPrice: Double?
    let targetPricePushHow: String?
    let dailyAlertTime: String?
}
