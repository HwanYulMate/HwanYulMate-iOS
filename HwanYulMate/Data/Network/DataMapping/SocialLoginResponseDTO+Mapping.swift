//
//  SocialLoginResponseDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

struct SocialLoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let user: UserResponseDTO
    let firstLogin: Bool
}

// MARK: - extensions
extension SocialLoginResponseDTO {
    struct UserResponseDTO: Decodable {
        let id: Int
        let name: String
        let email: String
        let provider: String
        let providerId: String
    }
}

extension SocialLoginResponseDTO.UserResponseDTO {
    func toEntity() -> User {
        return .init(
            name: name,
            email: email
        )
    }
}
