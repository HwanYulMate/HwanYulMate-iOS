//
//  AlertSettingsRepositoryImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation
import RxSwift

final class AlertSettingsRepositoryImpl: AlertSettingsRepository {
    
    // MARK: - properties
    private let remote: AlertSettingsRemoteDataSource
    private let local: AlertSettingsLocalDataSource
    
    // MARK: - life cycles
    init() {
        remote = AlertSettingsRemoteDataSourceImpl()
        local = AlertSettingsLocalDataSourceImpl()
    }
    
    // MARK: - methods
    func fetchAlertSetting(currencyCode: String) -> Single<AlertSetting> {
        return remote.fetchAlertSetting(
            token: local.getToken(),
            currencyCode: currencyCode
        ).map { $0.toEntity() }
    }
    
    func fetchAllAlertSettings() -> Single<[AlertSetting]> {
        return remote.fetchAllAlertSettings(token: local.getToken()).map { $0.map { $0.toEntity() } }
    }
}
