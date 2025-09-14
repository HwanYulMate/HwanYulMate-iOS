//
//  NewsView.swift
//  HwanYulMate
//
//  Created by HanJW on 8/28/25.
//

import UIKit
import SnapKit
import Then

final class NewsView: BaseView {
    
    // MARK: - Properties
    private let headerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "환율뉴스"
        $0.font = .pretendard(size: 20, weight: .semibold)
        $0.textColor = .black
    }
    
    private let searchContainerView = UIView().then {
        $0.backgroundColor = .textField
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    
    private let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "magnifying_glass")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .gray400
        $0.contentMode = .scaleAspectFit
    }
    
    let searchTextField = UITextField().then {
        $0.placeholder = "뉴스를 검색합니다"
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
    }
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Methods
    override func configureUI() {
        super.configureUI()
        tableView.refreshControl = refreshControl
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
    }
    
    override func configureHierarchy() {
        addSubview(headerView)
        addSubview(tableView)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(searchContainerView)
        
        searchContainerView.addSubview(searchImageView)
        searchContainerView.addSubview(searchTextField)
    }
    
    override func configureConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(128)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        searchContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    var onRefresh: (() -> Void)? {
        didSet {
            refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        }
    }
    
    @objc private func handleRefresh() {
        onRefresh?()
    }
}
