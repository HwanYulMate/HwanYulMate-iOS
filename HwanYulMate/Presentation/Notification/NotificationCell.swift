//
//  NotificationCell.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/30/25.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class NotificationCell: BaseTableViewCell {
    
    // MARK: - properties
    static let identifier = "NotificationCell"
    
    private let countryImageView = UIImageView()
    
    private let currencyNameLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray900
    }
    
    private let notificationButton = UIButton().then {
        $0.setImage(.notificationOff, for: .normal)
    }
    
    // MARK: - life cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryImageView.image = nil
        currencyNameLabel.text = nil
        notificationButton.setImage(.notificationOff, for: .normal)
    }
    
    // MARK: - methods
    override func configureUI() {
        selectionStyle = .none
    }
    
    override func configureHierarchy() {
        contentView.addSubview(countryImageView)
        contentView.addSubview(currencyNameLabel)
        contentView.addSubview(notificationButton)
    }
    
    override func configureConstraints() {
        countryImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(28)
            $0.height.equalTo(18)
        }
        
        currencyNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(countryImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(notificationButton.snp.leading).offset(-12)
        }
        
        notificationButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().offset(-26)
            $0.width.equalTo(16)
            $0.height.equalTo(20)
        }
    }
    
    func bind(alertSetting: AlertSetting) {
        countryImageView.kf.setImage(with: URL(string: AppConfig.shared.baseURL + alertSetting.flagImageUrl))
        currencyNameLabel.text = alertSetting.currencyName
        notificationButton.setImage(
            (alertSetting.isTargetPriceEnabled || alertSetting.isDailyAlertEnabled) ? .notificationOn : .notificationOff,
            for: .normal
        )
    }
}
