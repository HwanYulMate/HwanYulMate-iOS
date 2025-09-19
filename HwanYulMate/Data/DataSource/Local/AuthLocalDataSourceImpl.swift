//
//  AuthLocalDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

protocol AuthLocalDataSource {
    func isLoggedIn() -> Bool
    func saveTokens(access: String, refresh: String)
    func saveUser(name: String, email: String)
}

final class AuthLocalDataSourceImpl: AuthLocalDataSource {
    
    // MARK: - properties
    private let userDefaults: UserDefaults
    
    // MARK: - life cycles
    init() {
        self.userDefaults = .standard
    }
    
    // MARK: - methods
    func isLoggedIn() -> Bool {
        return userDefaults.string(forKey: "access") != nil
    }
    
    func saveTokens(access: String, refresh: String) {
        userDefaults.set(access, forKey: "access")
        userDefaults.set(refresh, forKey: "refresh")
    }
    
    func saveUser(name: String, email: String) {
        userDefaults.set(name, forKey: "name")
        userDefaults.set(email, forKey: "email")
    }
}
