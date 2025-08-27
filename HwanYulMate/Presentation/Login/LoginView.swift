//
//  LoginView.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/26/25.
//

import UIKit
import SnapKit
import Then

final class LoginView: BaseView {
    
    // MARK: - properties
    private let logoImageView = UIImageView().then {
        $0.image = .loginLogo
    }
    
    private let loginTitleLabel = UILabel().then {
        $0.text = "환율메이트 로그인"
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
        $0.textAlignment = .center
    }
    
    let googleLoginButton = UIButton()
    
    let appleLoginButton = UIButton()
    
    // MARK: - methods
    override func configureUI() {
        super.configureUI()
        
        configureSocialLoginButton(googleLoginButton, title: "Google로 로그인", image: .google)
        configureSocialLoginButton(appleLoginButton, title: "Apple로 로그인", image: .apple)
    }
    
    override func configureHierarchy() {
        addSubview(logoImageView)
        addSubview(loginTitleLabel)
        addSubview(googleLoginButton)
        addSubview(appleLoginButton)
    }
    
    override func configureConstraints() {
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.9)
        }
        
        loginTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(googleLoginButton.snp.top).offset(-32)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-16)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.centerY.equalToSuperview().multipliedBy(1.74)
        }
    }
    
    private func configureSocialLoginButton(
        _ button: UIButton,
        title: AttributedString,
        image: UIImage
    ) {
        var config = UIButton.Configuration.filled()
        config.image = image
        config.imagePadding = 10
        config.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)
        config.attributedTitle = title
        config.attributedTitle?.font = UIFont.pretendard(size: 19, weight: .medium)
        config.attributedTitle?.foregroundColor = UIColor.loginText
        config.background.strokeWidth = 1
        config.background.strokeColor = .gray900
        config.background.cornerRadius = 10
        button.configuration = config
        button.configurationUpdateHandler = { btn in
            var config = btn.configuration
            config?.baseBackgroundColor = btn.isHighlighted ? .gray50 : .clear
            btn.configuration = config
        }
    }
}
