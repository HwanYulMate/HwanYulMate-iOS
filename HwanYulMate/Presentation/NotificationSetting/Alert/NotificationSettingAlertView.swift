//
//  NotificationSettingAlertView.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import UIKit
import SnapKit
import Then

final class NotificationSettingAlertView: BaseView {
    
    // MARK: - properties
    private let backgroundView = UIView().then {
        $0.backgroundColor = .modalBackdrop
    }
    
    private let containerView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    private let completedImageView = UIImageView().then {
        $0.image = .notificationSettingAlertCompleted
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "알림 설정이 완료되었어요"
        $0.font = .pretendard(size: 18, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let doneButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: 14, leading: 0, bottom: 14, trailing: 0)
        config.attributedTitle = "확인"
        config.attributedTitle?.font = UIFont.pretendard(size: 18, weight: .medium)
        config.attributedTitle?.foregroundColor = UIColor.white
        config.background.cornerRadius = 12
        $0.configuration = config
        $0.configurationUpdateHandler = { btn in
            var config = btn.configuration
            config?.baseBackgroundColor = btn.isHighlighted ? .green600 : .green500
            btn.configuration = config
        }
    }
    
    // MARK: - methods
    override func configureUI() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(completedImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(doneButton)
    }
    
    override func configureConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        completedImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(53)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(completedImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(38)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
