//
//  NotificationView.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/30/25.
//

import UIKit
import SnapKit
import Then

final class NotificationView: BaseView {
    
    // MARK: - properties
    let backBarButtonItem = UIBarButtonItem().then {
        $0.style = .done
        $0.image = .arrowLeft
        $0.tintColor = .gray900
    }
    
    let navigationTitleLabel = UILabel().then {
        $0.text = "환율 알림 설정"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.bounces = false
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - methods
    override func configureHierarchy() {
        addSubview(tableView)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
