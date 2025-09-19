//
//  NoOperationSocialLoginService.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation
import RxSwift

final class NoOperationSocialLoginService: SocialLoginService {
    
    // MARK: - methods
    func login() -> Single<SocialLoginCredentialResponseDTO> {
        return .error(NSError(domain: "SocialLoginNotSupported", code: 0))
    }
}
