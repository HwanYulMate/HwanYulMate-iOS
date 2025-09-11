//
//  HomeDetailView.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import UIKit
import SnapKit
import Then

final class HomeDetailView: BaseView {
    
    // MARK: - properties
    let backBarButtonItem = UIBarButtonItem().then {
        $0.style = .done
        $0.image = .arrowLeft
        $0.tintColor = .gray900
    }
    
    let navigationTitleLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    let tableView = UITableView().then {
        $0.bounces = false
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    let exchangeEstimateComparisonButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: 14, leading: 0, bottom: 14, trailing: 0)
        config.attributedTitle = "환전 예상 금액 비교"
        config.attributedTitle?.font = UIFont.pretendard(size: 16, weight: .medium)
        config.attributedTitle?.foregroundColor = UIColor.white
        config.background.cornerRadius = 10
        $0.configuration = config
        $0.configurationUpdateHandler = { btn in
            var config = btn.configuration
            config?.baseBackgroundColor = btn.isHighlighted ? .green600 : .green500
            btn.configuration = config
        }
    }
    
    // MARK: - methods
    override func configureHierarchy() {
        addSubview(tableView)
        addSubview(exchangeEstimateComparisonButton)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        exchangeEstimateComparisonButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
}
