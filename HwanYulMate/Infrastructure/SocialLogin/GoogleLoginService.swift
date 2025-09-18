//
//  GoogleLoginService.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation
import GoogleSignIn
import RxSwift

final class GoogleLoginService {
    
    // MARK: - methods
    func login(vc: UIViewController) -> Single<SocialLoginCredentialResponseDTO> {
        return Single.create { single in
            GIDSignIn.sharedInstance.signIn(withPresenting: vc) { signInResult, error in
                guard error == nil else { return }
                guard let signInResult else { return }
                
                let response = SocialLoginCredentialResponseDTO(
                    user: signInResult.user.userID ?? "",
                    email: signInResult.user.profile?.email ?? "",
                    fullName: signInResult.user.profile?.name ?? "",
                    identityToken: signInResult.user.accessToken.tokenString,
                    authorizationCode: ""
                )
                
                single(.success(response))
            }
            
            return Disposables.create()
        }
    }
}
