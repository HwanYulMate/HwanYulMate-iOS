//
//  APIErrorResponse.swift
//  HwanYulMate
//
//  Created by HanJW on 9/18/25.
//

import Foundation

struct APIErrorResponse: Codable {
    
    // MARK: - response models
    let success: Bool
    let code: String
    let message: String
    let detail: String?
    let timestamp: String
    let path: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case code
        case message
        case detail
        case timestamp
        case path
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        code = try container.decodeIfPresent(String.self, forKey: .code) ?? "UNKNOWN_ERROR"
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? "알 수 없는 오류가 발생했습니다."
        detail = try container.decodeIfPresent(String.self, forKey: .detail)
        timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp) ?? ""
        path = try container.decodeIfPresent(String.self, forKey: .path) ?? ""
    }
}

extension APIErrorResponse {
    var isAlreadyWithdrawnError: Bool {
        return code == "COMMON_002" && detail?.contains("이미 탈퇴 처리된 사용자") == true
    }
    
    var userFriendlyMessage: String {
        if isAlreadyWithdrawnError {
            return "이미 탈퇴 처리된 계정입니다.\n현재 세션을 정리하고 로그인 화면으로 이동합니다."
        }
        
        return detail ?? message
    }
}
