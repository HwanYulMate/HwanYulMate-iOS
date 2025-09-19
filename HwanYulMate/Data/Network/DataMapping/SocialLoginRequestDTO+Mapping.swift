//
//  SocialLoginRequestDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

struct SocialLoginRequestDTO: Encodable {
    let accessToken: String
    let name: String
    let email: String
}
