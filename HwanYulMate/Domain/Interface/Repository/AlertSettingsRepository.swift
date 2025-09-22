//
//  AlertSettingsRepository.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation
import RxSwift

protocol AlertSettingsRepository {
    func fetchAlertSetting(currencyCode: String) -> Single<AlertSetting>
    func fetchAllAlertSettings() -> Single<[AlertSetting]>
    func enableTargetPriceAlert(
        currencyCode: String,
        targetPrice: Double,
        condition: String
    ) -> Single<TargetPrice>
    func disableTargetPriceAlert(currencyCode: String) -> Single<TargetPrice>
    func enableDailyAlert(
        currencyCode: String,
        alertTime: String
    ) -> Single<DailyAlert>
    func disableDailyAlert(
        currencyCode: String
    ) -> Single<DailyAlert>
}
