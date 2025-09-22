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

extension AuthLocalDataSourceImpl {
    
    func clearAllData() {
        userDefaults.removeObject(forKey: "access")
        userDefaults.removeObject(forKey: "refresh")
        userDefaults.removeObject(forKey: "name")
        userDefaults.removeObject(forKey: "email")
        userDefaults.synchronize()
        
        print("✅ [AuthLocalDataSource] 모든 로컬 데이터 삭제 완료")
    }
    
    func printCurrentStatus() {
        print("🔍 [AuthLocalDataSource] 현재 저장된 데이터:")
        print("   - access: \(userDefaults.string(forKey: "access") != nil ? "존재" : "없음")")
        print("   - refresh: \(userDefaults.string(forKey: "refresh") != nil ? "존재" : "없음")")
        print("   - name: \(userDefaults.string(forKey: "name") ?? "없음")")
        print("   - email: \(userDefaults.string(forKey: "email") ?? "없음")")
        print("   - isLoggedIn(): \(isLoggedIn())")
    }
}
