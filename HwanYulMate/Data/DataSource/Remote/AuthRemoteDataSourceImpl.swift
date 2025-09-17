//
//  AuthRemoteDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation
import RxSwift

protocol AuthRemoteDataSource {
    func socialLogin(
        accessToken: String,
        name: String,
        email: String,
        provider: SocialProvider
    ) -> Single<SocialLoginResponseDTO>
}

final class AuthRemoteDataSourceImpl: AuthRemoteDataSource {
    
    // MARK: - properties
    private let networkService: NetworkService
    
    // MARK: - life cycles
    init() {
        networkService = NetworkService()
    }
    
    // MARK: - methods
    func socialLogin(
        accessToken: String,
        name: String,
        email: String,
        provider: SocialProvider
    ) -> Single<SocialLoginResponseDTO> {
        let request = SocialLoginRequestDTO(accessToken: accessToken, name: name, email: email)
        let endpoint = AuthEndpoint.socialLogin(request: request, provider: provider)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as SocialLoginResponseDTO
        }
    }
}
