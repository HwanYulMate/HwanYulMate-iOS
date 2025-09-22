//
//  TokenStorage.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/21/25.
//

import Foundation

final class TokenStorage {
    
    // MARK: - nested types
    enum TokenType: String {
        case fcm
    }
    
    // MARK: - properties
    static let shared = TokenStorage()
    private init() {}
    
    // MARK: - methods
    func save(token: String, type: TokenType) {
        UserDefaults.standard.set(token, forKey: type.rawValue)
    }
    
    func load(_ type: TokenType) -> String? {
        return UserDefaults.standard.string(forKey: type.rawValue)
    }
}
