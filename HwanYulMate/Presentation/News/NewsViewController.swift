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
    private var allNews: [NewsModel] = NewsModel.mockData
    private var filteredNews: [NewsModel] = []
    private var isSearching = false
    
    // MARK: - Life Cycles
    override func loadView() {
        view = newsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchTextField()
        setupRefreshControl()
        
        filteredNews = allNews
    }
    
    // MARK: - Methods
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
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if searchText.isEmpty {
            isSearching = false
            filteredNews = allNews
        } else {
            isSearching = true
            filteredNews = allNews.filter { news in
                news.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.newsView.tableView.reloadData()
        }
    }
    
    private func refreshNews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            self.allNews = NewsModel.mockData
            
            if !self.isSearching {
                self.filteredNews = self.allNews
            } else {
                let searchText = self.newsView.searchTextField.text ?? ""
                self.filteredNews = self.allNews.filter { news in
                    news.title.lowercased().contains(searchText.lowercased())
                }
            }
            
            self.newsView.tableView.reloadData()
            self.newsView.endRefreshing()
        }
    }
    
    private func openNewsURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            showAlert(title: "오류", message: "유효하지 않은 URL입니다.")
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredBarTintColor = .white
        safariViewController.preferredControlTintColor = .main
        present(safariViewController, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
        print("Selected news: \(selectedNews.title)")
        
        // TODO: Out Link - Naver API
        openNewsURL(selectedNews.url)
    }
}

extension NewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
