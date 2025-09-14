//
//  NewsViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 8/28/25.
//

import UIKit
import SafariServices

final class NewsViewController: UIViewController {
    
    // MARK: - Properties
    private let newsView = NewsView()
    private let networkService = NewsNetworkService.shared
    
    private var allNews: [NewsModel] = []
    private var filteredNews: [NewsModel] = []
    private var isSearching = false
    private var isLoading = false
    private var currentPage = 0
    
    // MARK: - Constants
    private enum Constants {
        static let defaultSearchKeyword = "달러"
        static let pageSize = 10
    }
    
    // MARK: - Life Cycles
    override func loadView() {
        view = newsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialNews()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupTableView()
        setupSearchTextField()
        setupRefreshControl()
    }
    
    private func setupTableView() {
        newsView.tableView.dataSource = self
        newsView.tableView.delegate = self
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
    
    // MARK: - Data Loading Methods
    private func loadInitialNews() {
        loadNews(keyword: Constants.defaultSearchKeyword, page: 0)
    }
    
    private func loadNews(keyword: String, page: Int) {
        guard !isLoading else { return }
        
        isLoading = true
        newsView.showLoading()
        
        networkService.searchNews(
            searchKeyword: keyword,
            page: page,
            size: Constants.pageSize
        ) { [weak self] result in
            self?.handleNewsResult(result)
        }
    }
    
    private func handleNewsResult(_ result: Result<[NewsModel], NetworkError>) {
        isLoading = false
        newsView.hideLoading()
        
        switch result {
        case .success(let news):
            updateNewsData(with: news)
        case .failure(let error):
            handleNetworkError(error)
        }
    }
    
    private func updateNewsData(with news: [NewsModel]) {
        allNews = news
        if !isSearching {
            filteredNews = news
        }
        newsView.tableView.reloadData()
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        print("네트워크 오류: \(error.localizedDescription)")
        // 목업 데이터로 폴백
        allNews = NewsModel.mockData
        filteredNews = allNews
        newsView.tableView.reloadData()
        showAlert(title: "네트워크 오류", message: "목업 데이터를 표시합니다.")
    }
    
    // MARK: - Search Methods
    @objc private func searchTextChanged(_ textField: UITextField) {
        let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        performSearch(with: searchText)
    }
    
    private func performSearch(with searchText: String) {
        if searchText.isEmpty {
            resetToAllNews()
        } else {
            filterNews(with: searchText)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.newsView.tableView.reloadData()
        }
    }
    
    private func resetToAllNews() {
        isSearching = false
        filteredNews = allNews
    }
    
    private func filterNews(with searchText: String) {
        isSearching = true
        filteredNews = allNews.filter { news in
            news.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Refresh Methods
    private func refreshNews() {
        guard !isLoading else {
            newsView.endRefreshing()
            return
        }
        
        let keyword = getCurrentSearchKeyword()
        refreshNewsData(with: keyword)
    }
    
    private func getCurrentSearchKeyword() -> String {
        if isSearching {
            return newsView.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? Constants.defaultSearchKeyword
        }
        return Constants.defaultSearchKeyword
    }
    
    private func refreshNewsData(with keyword: String) {
        isLoading = true
        
        networkService.searchNews(
            searchKeyword: keyword,
            page: 0,
            size: Constants.pageSize
        ) { [weak self] result in
            self?.handleRefreshResult(result, keyword: keyword)
        }
    }
    
    private func handleRefreshResult(_ result: Result<[NewsModel], NetworkError>, keyword: String) {
        isLoading = false
        newsView.endRefreshing()
        
        switch result {
        case .success(let news):
            updateRefreshedNews(with: news, keyword: keyword)
        case .failure(let error):
            showAlert(title: "새로고침 실패", message: error.localizedDescription)
        }
    }
    
    private func updateRefreshedNews(with news: [NewsModel], keyword: String) {
        allNews = news
        
        if !isSearching {
            filteredNews = news
        } else {
            filterNews(with: keyword)
        }
        
        newsView.tableView.reloadData()
    }
    
    // MARK: - Navigation Methods
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
            self?.newsView.hideLoading()
            self?.handleOriginalLinkResult(result, fallbackNews: news)
        }
    }
    
    private func handleOriginalLinkResult(_ result: Result<String, NetworkError>, fallbackNews: NewsModel) {
        switch result {
        case .success(let urlString):
            if let url = URL(string: urlString) {
                openSafariViewController(with: url)
            } else {
                showInvalidURLAlert()
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
            showAlert(title: "오류", message: "뉴스 링크를 열 수 없습니다.")
        }
    }
    
    private func openSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredBarTintColor = .white
        safariViewController.preferredControlTintColor = .main
        present(safariViewController, animated: true)
    }
    
    // MARK: - Alert Methods
    private func showInvalidURLAlert() {
        showAlert(title: "오류", message: "유효하지 않은 URL입니다.")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedNews = filteredNews[indexPath.row]
        openNewsURL(for: selectedNews)
    }
}

// MARK: - UITextFieldDelegate
extension NewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
