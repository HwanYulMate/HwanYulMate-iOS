//
//  NotificationHeaderView.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/31/25.
//

import UIKit
import SnapKit
import Then

final class NotificationHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - properties
    static let identifier = "NotificationHeaderView"
    
    private let titleLabel = UILabel().then {
        $0.text = "어느 국가의 환율을\n알림 받으시겠어요?"
        $0.font = .pretendard(size: 20, weight: .semibold)
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 8)
    }
    
    private let currencyNotificationLabel = UILabel().then {
        $0.text = "통화별 알림"
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
    }
    
    // MARK: - life cycles
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods
    private func configureUI() {
        contentView.backgroundColor = .white
    }
    
    private func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(currencyNotificationLabel)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        currencyNotificationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(42)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
    }
}
