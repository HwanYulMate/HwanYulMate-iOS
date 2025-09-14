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
        $0.keyboardDismissMode = .onDrag
    }
    
    private let refreshControl = UIRefreshControl()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
        $0.color = .main
    }
    
    // MARK: - Constants
    private enum Constants {
        static let headerHeight: CGFloat = 128
        static let headerPadding: CGFloat = 16
        static let titleSearchSpacing: CGFloat = 26
        static let searchHeight: CGFloat = 44
        static let searchHorizontalPadding: CGFloat = 12
        static let searchIconSize: CGFloat = 18
        static let searchIconTextSpacing: CGFloat = 8
    }
    
    // MARK: - Callbacks
    var onRefresh: (() -> Void)? {
        didSet {
            setupRefreshControl()
        }
    }
    
    // MARK: - Methods
    override func configureUI() {
        super.configureUI()
        setupTableView()
    }
    
    override func configureHierarchy() {
        [headerView, tableView, loadingIndicator].forEach { addSubview($0) }
        [titleLabel, searchContainerView].forEach { headerView.addSubview($0) }
        [searchImageView, searchTextField].forEach { searchContainerView.addSubview($0) }
    }
    
    override func configureConstraints() {
        setupHeaderConstraints()
        setupTableViewConstraints()
        setupLoadingIndicatorConstraints()
    }
    
    // MARK: - Public Methods
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        tableView.isUserInteractionEnabled = true
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupHeaderConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.headerHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.headerPadding)
            $0.leading.trailing.equalToSuperview().inset(Constants.headerPadding)
        }
        
        searchContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.titleSearchSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.headerPadding)
            $0.height.equalTo(Constants.searchHeight)
            $0.bottom.equalToSuperview().offset(-Constants.headerPadding)
        }
        
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.searchHorizontalPadding)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.searchIconSize)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(Constants.searchIconTextSpacing)
            $0.trailing.equalToSuperview().offset(-Constants.searchHorizontalPadding)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setupLoadingIndicatorConstraints() {
        loadingIndicator.snp.makeConstraints {
            $0.center.equalTo(tableView)
        }
    }
    
    @objc private func handleRefresh() {
        onRefresh?()
    }
}
