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
    
    // MARK: - properties
    private let headerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "환율뉴스"
        $0.font = .pretendard(size: 20, weight: .semibold)
        $0.textColor = .black
    }
    
    let searchContainerView = UIView().then {
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
        $0.textColor = .gray900
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .search
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.keyboardDismissMode = .onDrag
        $0.contentInsetAdjustmentBehavior = .automatic
    }
    
    private let refreshControl = UIRefreshControl()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
        $0.color = .main
    }
    
    private let loadingMoreIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
        $0.color = .main
        $0.backgroundColor = .white
    }
    
    private let emptyStateView = EmptyStateView()
    
    private enum Constants {
        static let headerHeight: CGFloat = 128
        static let headerPadding: CGFloat = 16
        static let titleSearchSpacing: CGFloat = 26
        static let searchHeight: CGFloat = 44
        static let searchHorizontalPadding: CGFloat = 12
        static let searchIconSize: CGFloat = 18
        static let searchIconTextSpacing: CGFloat = 8
        static let loadingMoreHeight: CGFloat = 50
    }
    
    var onRefresh: (() -> Void)? {
        didSet {
            setupRefreshControl()
        }
    }
    
    // MARK: - methods
    override func configureUI() {
        super.configureUI()
        setupTableView()
        setupEmptyState()
        setupLoadingMore()
    }
    
    override func configureHierarchy() {
        [headerView, tableView, loadingIndicator, loadingMoreIndicator, emptyStateView].forEach { addSubview($0) }
        [titleLabel, searchContainerView].forEach { headerView.addSubview($0) }
        [searchImageView, searchTextField].forEach { searchContainerView.addSubview($0) }
    }
    
    override func configureConstraints() {
        setupHeaderConstraints()
        setupTableViewConstraints()
        setupLoadingIndicatorConstraints()
        setupLoadingMoreConstraints()
        setupEmptyStateConstraints()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
        emptyStateView.isHidden = true
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        tableView.isUserInteractionEnabled = true
    }
    
    func showLoadingMore() {
        loadingMoreIndicator.startAnimating()
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: Constants.loadingMoreHeight))
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .main
        indicator.startAnimating()
        indicator.center = footerView.center
        footerView.addSubview(indicator)
        
        tableView.tableFooterView = footerView
    }
    
    func hideLoadingMore() {
        loadingMoreIndicator.stopAnimating()
        tableView.tableFooterView = nil
    }
    
    func showEmptyState(title: String, message: String) {
        emptyStateView.configure(title: title, message: message)
        emptyStateView.isHidden = false
    }
    
    func hideEmptyState() {
        emptyStateView.isHidden = true
    }
    
    func updateEmptyState(for newsCount: Int, isSearching: Bool) {
        if newsCount == 0 {
            if isSearching {
                showEmptyState(
                    title: "검색 결과가 없습니다",
                    message: "다른 검색어로 시도해보세요"
                )
            } else {
                showEmptyState(
                    title: "뉴스를 불러올 수 없습니다",
                    message: "네트워크 연결을 확인하고\n아래로 당겨서 새로고침해주세요"
                )
            }
        } else {
            hideEmptyState()
        }
    }
    
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupEmptyState() {
        emptyStateView.isHidden = true
    }
    
    private func setupLoadingMore() {
        loadingMoreIndicator.isHidden = true
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
    
    private func setupLoadingMoreConstraints() {
        loadingMoreIndicator.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
    }
    
    private func setupEmptyStateConstraints() {
        emptyStateView.snp.makeConstraints {
            $0.center.equalTo(tableView)
            $0.leading.trailing.equalTo(tableView).inset(20)
        }
    }
    
    @objc private func handleRefresh() {
        onRefresh?()
    }
}

final class EmptyStateView: UIView {
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(systemName: "newspaper")
        $0.tintColor = .systemGray3
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(size: 18, weight: .semibold)
        $0.textColor = .systemGray
        $0.textAlignment = .center
    }
    
    private let messageLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .systemGray2
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(stackView)
        [imageView, titleLabel, messageLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
    }
    
    func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
}
