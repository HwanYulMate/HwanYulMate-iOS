//
//  AppleLoginService.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation
import AuthenticationServices
import RxSwift

final class AppleLoginService: NSObject, SocialLoginService {
    
    // MARK: - methods
    func login() -> Single<SocialLoginCredentialResponseDTO> {
        return Single.create { single in
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.presentationContextProvider = self
            
            let success = authorizationController.rx.didCompleteWithAuthorization
                .take(1)
                .subscribe { authorization in
                    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
                    
                    let response = SocialLoginCredentialResponseDTO(
                        user: credential.user,
                        email: credential.email ?? "",
                        fullName: (credential.fullName?.familyName ?? "") + (credential.fullName?.givenName ?? ""),
                        identityToken: credential.identityToken.flatMap { String(data: $0, encoding: .utf8) } ?? "",
                        authorizationCode: credential.authorizationCode.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                    )
                    
                    single(.success(response))
                }
            
            let failure = authorizationController.rx.didCompleteWithError
                .take(1)
                .subscribe { error in
                    single(.failure(error))
                }
            
            authorizationController.performRequests()
            
            return Disposables.create {
                success.dispose()
                failure.dispose()
            }
        }
    }
}

// MARK: - extensions
extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first ?? UIWindow()
    }
}
