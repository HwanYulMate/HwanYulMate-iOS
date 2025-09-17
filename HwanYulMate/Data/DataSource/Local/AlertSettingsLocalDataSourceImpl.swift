//
//  AlertSettingsLocalDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation

protocol AlertSettingsLocalDataSource {
    func getToken() -> String
}

final class AlertSettingsLocalDataSourceImpl: AlertSettingsLocalDataSource {
    
    // MARK: - properties
    private let userDefaults: UserDefaults
    
    // MARK: - life cycles
    init() {
        self.userDefaults = .standard
    }
    
    // MARK: - methods
    func getToken() -> String {
        return userDefaults.string(forKey: "access")!
    }
}
