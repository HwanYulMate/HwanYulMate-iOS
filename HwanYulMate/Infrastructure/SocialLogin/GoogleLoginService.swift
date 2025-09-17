//
//  GoogleLoginService.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation
import RxSwift
import GoogleSignIn

//final class GoogleLoginService: SocialLoginService {
//    
//    // MARK: - methods
//    func login() -> Single<SocialLoginCredentialResponseDTO> {
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
//            guard error == nil else { return }
//            guard let signInResult = signInResult else { return }
//            
//            let user = signInResult.user
//            
//            let emailAddress = user.profile?.email
//            
//            let fullName = user.profile?.name
//            let givenName = user.profile?.givenName
//            let familyName = user.profile?.familyName
//            
//            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
//        }
//    }
//}
