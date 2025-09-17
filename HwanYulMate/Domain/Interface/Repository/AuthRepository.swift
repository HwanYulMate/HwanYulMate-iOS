//
//  AuthRepository.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation
import RxSwift

enum SocialProvider: String {
    case apple
    case google
}

protocol AuthRepository {
    func isLoggedIn() -> Bool
    func socialLogin(provider: SocialProvider) -> Single<User>
}
