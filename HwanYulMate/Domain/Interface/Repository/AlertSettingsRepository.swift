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
}
