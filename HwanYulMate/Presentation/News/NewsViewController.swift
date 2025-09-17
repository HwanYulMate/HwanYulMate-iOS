//
//  NewsViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 8/28/25.
//

//  NewsViewController.swift
import UIKit
import SafariServices

final class NewsViewController: UIViewController {
    
    // MARK: - properties
    private let newsView = NewsView()
    private let networkService = NewsNetworkService.shared
    
    private var allNews: [NewsModel] = []
    private var filteredNews: [NewsModel] = []
    private var isSearching = false
    private var isLoading = false
    private var isLoadingMore = false
    private var currentPage = 0
    private var hasNextPage = true
    private var searchWorkItem: DispatchWorkItem?
    
    private enum Constants {
        static let defaultSearchKeyword = "달러"
        static let pageSize = 10
        static let searchDebounceTime: TimeInterval = 0.5
        static let prefetchThreshold = 3 // 마지막에서 3개 남았을 때 다음 페이지 로드
    }
    
    // MARK: - life cycles
    override func loadView() {
        view = newsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    // MARK: - methods (setting up)
    private func setupUI() {
        setupTableView()
        setupSearchTextField()
        setupRefreshControl()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTableView() {
        newsView.tableView.dataSource = self
        newsView.tableView.delegate = self
        newsView.tableView.prefetchDataSource = self
    }
    
    private func setupSearchTextField() {
        newsView.searchTextField.addTarget(
            self,
            action: #selector(searchTextChanged(_:)),
            for: .editingChanged
        )
        newsView.searchTextField.delegate = self
    }
    
    private func setupRefreshControl() {
        newsView.onRefresh = { [weak self] in
            self?.refreshNews()
        }
    }
    
    // MARK: - methods (keyboard handling)
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        newsView.tableView.contentInset = contentInset
        newsView.tableView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        newsView.tableView.contentInset = .zero
        newsView.tableView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - methods (data loading)
    private func loadInitialNews() {
        resetPaginationState()
        loadPaginatedNews(page: 0, isRefresh: false)
    }
    
    private func loadPaginatedNews(page: Int, isRefresh: Bool) {
        guard !isLoading && !isLoadingMore else { return }
        
        if page == 0 {
            isLoading = true
            if !isRefresh {
                newsView.showLoading()
            }
        } else {
            isLoadingMore = true
            newsView.showLoadingMore()
        }
        
        networkService.fetchPaginatedNews(
            page: page,
            size: Constants.pageSize
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.handlePaginatedNewsResult(result, page: page, isRefresh: isRefresh)
            }
        }
    }
    
    private func handlePaginatedNewsResult(
        _ result: Result<NewsSearchResponse, NetworkError>,
        page: Int,
        isRefresh: Bool
    ) {
        isLoading = false
        isLoadingMore = false
        
        if isRefresh {
            newsView.endRefreshing()
        } else {
            newsView.hideLoading()
        }
        
        newsView.hideLoadingMore()
        
        switch result {
        case .success(let response):
            handleSuccessfulPaginatedResponse(response, page: page)
        case .failure(let error):
            handlePaginatedNewsError(error, page: page)
        }
    }
    
    private func handleSuccessfulPaginatedResponse(_ response: NewsSearchResponse, page: Int) {
        let newNewsModels = response.newsList.map { $0.toNewsModel() }
        
        if page == 0 {
            allNews = newNewsModels
            resetPaginationState()
        } else {
            allNews.append(contentsOf: newNewsModels)
        }
        
        currentPage = response.currentPage
        hasNextPage = response.hasNext
        
        if !isSearching {
            filteredNews = allNews
        }
        
        reloadTableViewData()
        
        print("📄 [Pagination] Loaded page \(currentPage), hasNext: \(hasNextPage), total items: \(allNews.count)")
    }
    
    private func handlePaginatedNewsError(_ error: NetworkError, page: Int) {
        print("네트워크 오류: \(error.localizedDescription)")
        
        if page == 0 {
            allNews = NewsModel.mockData
            filteredNews = allNews
            resetPaginationState()
            reloadTableViewData()
            showToast(message: "네트워크 연결을 확인해주세요")
        } else {
            showToast(message: "더 많은 뉴스를 불러올 수 없습니다")
        }
    }
    
    private func resetPaginationState() {
        currentPage = 0
        hasNextPage = true
    }
    
    private func reloadTableViewData() {
        newsView.tableView.reloadData()
        newsView.updateEmptyState(for: filteredNews.count, isSearching: isSearching)
    }
    
    // MARK: - methods (searching)
    @objc private func searchTextChanged(_ textField: UITextField) {
        searchWorkItem?.cancel()
        
        let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        searchWorkItem = DispatchWorkItem { [weak self] in
            self?.performSearch(with: searchText)
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + Constants.searchDebounceTime,
            execute: searchWorkItem!
        )
    }
    
    private func performSearch(with searchText: String) {
        if searchText.isEmpty {
            resetToAllNews()
        } else {
            filterNews(with: searchText)
        }
        
        reloadTableViewData()
    }
    
    private func resetToAllNews() {
        isSearching = false
        filteredNews = allNews
    }
    
    private func filterNews(with searchText: String) {
        isSearching = true
        filteredNews = allNews.filter { news in
            news.title.localizedCaseInsensitiveContains(searchText) ||
            news.description?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    // MARK: - methods (refreshing)
    private func refreshNews() {
        guard !isLoading && !isLoadingMore else {
            newsView.endRefreshing()
            return
        }
        
        if isSearching {
            refreshSearchData()
        } else {
            loadPaginatedNews(page: 0, isRefresh: true)
        }
    }
    
    private func refreshSearchData() {
        guard let searchText = newsView.searchTextField.text,
              !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            newsView.endRefreshing()
            return
        }
        
        isLoading = true
        
        networkService.searchNews(
            searchKeyword: searchText.trimmingCharacters(in: .whitespacesAndNewlines),
            page: 0,
            size: Constants.pageSize
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleSearchRefreshResult(result)
            }
        }
    }
    
    private func handleSearchRefreshResult(_ result: Result<[NewsModel], NetworkError>) {
        isLoading = false
        newsView.endRefreshing()
        
        switch result {
        case .success(let news):
            allNews = news
            if isSearching {
                if let searchText = newsView.searchTextField.text {
                    filterNews(with: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            } else {
                filteredNews = news
            }
            reloadTableViewData()
        case .failure(let error):
            showToast(message: "새로고침 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - methods (infinite scroll)
    private func loadMoreNewsIfNeeded(for indexPath: IndexPath) {
        guard !isSearching,
              hasNextPage,
              !isLoadingMore,
              indexPath.row >= filteredNews.count - Constants.prefetchThreshold
        else { return }
        
        let nextPage = currentPage + 1
        print("📄 [Pagination] Loading more news - page: \(nextPage)")
        loadPaginatedNews(page: nextPage, isRefresh: false)
    }
    
    // MARK: - methods (navigation)
    private func openNewsURL(for news: NewsModel) {
        if let validURL = getValidURL(from: news) {
            openSafariViewController(with: validURL)
        } else {
            fetchAndOpenOriginalLink(for: news)
        }
    }
    
    private func getValidURL(from news: NewsModel) -> URL? {
        if let link = news.link, !link.isEmpty, let url = URL(string: link) {
            return url
        }
        return nil
    }
    
    private func fetchAndOpenOriginalLink(for news: NewsModel) {
        newsView.showLoading()
        
        networkService.getNewsOriginalLink(for: news.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.newsView.hideLoading()
                self?.handleOriginalLinkResult(result, fallbackNews: news)
            }
        }
    }
    
    private func handleOriginalLinkResult(_ result: Result<String, NetworkError>, fallbackNews: NewsModel) {
        switch result {
        case .success(let urlString):
            if let url = URL(string: urlString) {
                openSafariViewController(with: url)
            } else {
                showToast(message: "유효하지 않은 URL입니다")
            }
        case .failure(let error):
            handleOriginalLinkFailure(error, fallbackNews: fallbackNews)
        }
    }
    
    private func handleOriginalLinkFailure(_ error: NetworkError, fallbackNews: NewsModel) {
        print("원본 링크 가져오기 실패: \(error.localizedDescription)")
        
        if let url = URL(string: fallbackNews.url) {
            openSafariViewController(with: url)
        } else {
            showToast(message: "뉴스 링크를 열 수 없습니다")
        }
    }
    
    private func openSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredBarTintColor = .white
        safariViewController.preferredControlTintColor = .main
        present(safariViewController, animated: true)
    }
    
    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsCell.identifier,
            for: indexPath
        ) as? NewsCell else {
            return UITableViewCell()
        }
        
        let news = filteredNews[indexPath.row]
        let searchText = isSearching ? (newsView.searchTextField.text ?? "") : ""
        
        cell.configure(with: news, searchText: searchText)
        
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedNews = filteredNews[indexPath.row]
        openNewsURL(for: selectedNews)
        
        print("뉴스 선택됨: \(selectedNews.title)")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreNewsIfNeeded(for: indexPath)
        
        let shouldAnimate = indexPath.row < 5 ||
                           (indexPath.row >= filteredNews.count - Constants.pageSize)
        
        if shouldAnimate {
            cell.alpha = 0
            UIView.animate(withDuration: 0.25) {
                cell.alpha = 1
            }
        } else {
            cell.alpha = 1
        }
    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            loadMoreNewsIfNeeded(for: indexPath)
        }
    }
}

extension NewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        newsView.searchContainerView.layer.borderColor = UIColor.main.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newsView.searchContainerView.layer.borderColor = UIColor.gray100.cgColor
    }
}
