//
//  HomeView.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/24/25.
//

import UIKit
import SnapKit
import Then

final class HomeView: BaseView {
    
    // MARK: - properties
    private let headerView = UIView().then {
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.text = "실시간 환율 정보를\n조회해보세요"
        $0.font = .pretendard(size: 20, weight: .semibold)
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 8)
    }
    
    let notificationSettingButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 8
        config.background.backgroundColor = .gray50
        $0.configuration = config
    }
    
    private let notificationImageView = UIImageView().then {
        $0.image = .notification
    }
    
    private let notificationLabel = UILabel().then {
        $0.text = "환율 알림 설정하기"
        $0.font = .pretendard(size: 16, weight: .medium)
    }
    
    private let notificationArrowImageView = UIImageView().then {
        $0.image = .arrowRight
    }
    
    private let tableTitleLabel = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .semibold)
        $0.textColor = .gray400
    }
    
    let tableView = UITableView().then {
        $0.bounces = false
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    var headerHeightConstraint: Constraint?
    let maxHeaderHeight: CGFloat = 152
    let minHeaderHeight: CGFloat = 60
    
    // MARK: - methods
    override func configureHierarchy() {
        addSubview(headerView)
        addSubview(notificationSettingButton)
        addSubview(tableTitleLabel)
        addSubview(tableView)
        headerView.addSubview(titleLabel)
        notificationSettingButton.addSubview(notificationImageView)
        notificationSettingButton.addSubview(notificationLabel)
        notificationSettingButton.addSubview(notificationArrowImageView)
    }
    
    override func configureConstraints() {
        headerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            headerHeightConstraint = $0.height.equalTo(maxHeaderHeight).constraint
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        notificationSettingButton.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        notificationImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        notificationLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18)
            $0.leading.equalTo(notificationImageView.snp.trailing).offset(12)
        }
        
        notificationArrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        tableTitleLabel.snp.makeConstraints {
            $0.top.equalTo(notificationSettingButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(tableTitleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
