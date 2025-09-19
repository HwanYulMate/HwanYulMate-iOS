//
//  AuthRepositoryImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation
import RxSwift

final class AuthRepositoryImpl: AuthRepository {
    
    // MARK: - properties
    private let remote: AuthRemoteDataSource
    private let local: AuthLocalDataSource
    private var social: SocialLoginService
    
    // MARK: - life cycles
    init(
        remote: AuthRemoteDataSource = AuthRemoteDataSourceImpl(),
        local: AuthLocalDataSource = AuthLocalDataSourceImpl(),
        social: SocialLoginService = NoOperationSocialLoginService()
    ) {
        self.remote = remote
        self.local = local
        self.social = social
    }
    
    // MARK: - methods
    func isLoggedIn() -> Bool {
        return local.isLoggedIn()
    }
    
    func socialLogin(provider: SocialProvider) -> Single<User> {
        switch provider {
        case .apple:
            social = AppleLoginService()
        case .google:
            break
        }
        
        return social.login()
            .flatMap { credential in
                self.remote.socialLogin(
                    accessToken: credential.identityToken,
                    name: credential.fullName,
                    email: credential.email,
                    provider: provider
                )
            }
            .do { dto in
                self.local.saveTokens(access: dto.accessToken, refresh: dto.refreshToken)
                self.local.saveUser(name: dto.user.name, email: dto.user.email)
            }
            .map { $0.user.toEntity() }
    }
}
