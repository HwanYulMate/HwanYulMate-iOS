//
//  RxASAuthorizationControllerDelegateProxy.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation
import AuthenticationServices
import RxSwift
import RxCocoa

final class RxASAuthorizationControllerDelegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate {
    
    // MARK: - methods
    static func registerKnownImplementations() {
        self.register { RxASAuthorizationControllerDelegateProxy(parentObject: $0, delegateProxy: self) }
    }
    
    static func currentDelegate(
        for object: ASAuthorizationController
    ) -> (any ASAuthorizationControllerDelegate)? {
        object.delegate
    }
    
    static func setCurrentDelegate(
        _ delegate: (any ASAuthorizationControllerDelegate)?,
        to object: ASAuthorizationController
    ) {
        object.delegate = delegate
    }
}

// MARK: - extensions
extension Reactive where Base: ASAuthorizationController {
    var delegate: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
        RxASAuthorizationControllerDelegateProxy.proxy(for: self.base)
    }
    
    var didCompleteWithAuthorization: Observable<ASAuthorization> {
        delegate
            .methodInvoked(
                #selector(
                    ASAuthorizationControllerDelegate.authorizationController(
                        controller:didCompleteWithAuthorization:
                    )
                )
            )
            .compactMap { $0[1] as? ASAuthorization }
    }
    
    var didCompleteWithError: Observable<Error> {
        delegate
            .methodInvoked(
                #selector(
                    ASAuthorizationControllerDelegate.authorizationController(
                        controller:didCompleteWithError:
                    )
                )
            )
            .compactMap { $0[1] as? Error }
    }
}
