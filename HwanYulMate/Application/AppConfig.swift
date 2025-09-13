//
//  AppConfig.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation

final class AppConfig {
    
    // MARK: - properties
    static let shared = AppConfig()
    private init() {}
    
    var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL not set in Info.plist")
        }
        
        return url
    }
}
