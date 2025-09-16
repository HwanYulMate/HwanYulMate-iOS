//
//  LogoutView.swift
//  HwanYulMate
//
//  Created by HanJW on 9/4/25.
//

import UIKit
import SnapKit
import Then

final class LogoutView: BaseView {
    
    // MARK: - properties
    private let navigationBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    let backButton = UIButton(type: .system).then {
        let image = UIImage(systemName: "chevron.left")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        )
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "로그아웃"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logout_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let messageLabel = UILabel().then {
        $0.text = "로그아웃 하시겠습니까?"
        $0.font = .pretendard(size: 18, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.main, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.buttonLine.cgColor
        $0.titleLabel?.font = .pretendard(size: 16, weight: .medium)
    }
    
    let confirmButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .pretendard(size: 16, weight: .medium)
    }
    
    // MARK: - methods
    override func configureUI() {
        super.configureUI()
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(navigationBar)
        addSubview(logoImageView)
        addSubview(messageLabel)
        addSubview(cancelButton)
        addSubview(confirmButton)
        
        navigationBar.addSubview(backButton)
        navigationBar.addSubview(titleLabel)
    }
    
    override func configureConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-60)
            $0.width.height.equalTo(64)
        }
        
        messageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(28)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(48)
            $0.trailing.equalTo(confirmButton.snp.leading).offset(-12)
        }
        
        confirmButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(48)
            $0.width.equalTo(cancelButton.snp.width)
        }
    }
}
