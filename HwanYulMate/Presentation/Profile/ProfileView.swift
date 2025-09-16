//
//  ProfileView.swift
//  HwanYulMate
//
//  Created by HanJW on 9/1/25.
//

import UIKit
import SnapKit
import Then

final class ProfileView: BaseView {
    
    // MARK: - properties
    private let navigationBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "프로필"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - methods
    override func configureUI() {
        super.configureUI()
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(navigationBar)
        addSubview(tableView)
        
        navigationBar.addSubview(titleLabel)
    }
    
    override func configureConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(33)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
