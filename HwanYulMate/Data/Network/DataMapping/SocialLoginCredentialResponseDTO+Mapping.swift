//
//  SocialLoginCredentialResponseDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

struct SocialLoginCredentialResponseDTO {
    let user: String
    let email: String
    let fullName: String
    let identityToken: String
    let authorizationCode: String
}
