//
//  LoginViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/26/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class LoginViewController: UIViewController, View {
    
    // MARK: - properties
    private let loginView = LoginView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = loginView
    }
    
    // MARK: - methods
    func bind(reactor: LoginReactor) {
        loginView.backButton.rx.tap
            .map { LoginReactor.Action.tapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginView.googleLoginButton.rx.tap
            .map { LoginReactor.Action.tapGoogleLoginButton(self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginView.appleLoginButton.rx.tap
            .map { LoginReactor.Action.tapAppleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .dismiss:
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
