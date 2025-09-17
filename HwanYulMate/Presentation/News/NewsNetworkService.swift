//
//  NewsNetworkService.swift
//  HwanYulMate
//
//  Created by HanJW on 9/12/25.
//

import Foundation

final class NewsNetworkService {
    static let shared = NewsNetworkService()
    
    var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL not set in Info.plist")
        }
        return url
    }
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - methods
    /// 페이지네이션을 지원하는 뉴스 목록 조회
    func fetchPaginatedNews(
        page: Int = 0,
        size: Int = 10,
        completion: @escaping (Result<NewsSearchResponse, NetworkError>) -> Void
    ) {
        guard let url = buildPaginatedNewsURL(page: page, size: size) else {
            logError("Failed to build paginated news URL")
            completion(.failure(.invalidURL))
            return
        }
        
        let request = createGETRequest(for: url)
        logRequest(request, description: "Fetching paginated news")
        
        performPaginatedNewsRequest(with: request, completion: completion)
    }
    
    /// 검색어 기반 뉴스 조회
    func searchNews(
        searchKeyword: String = "달러",
        page: Int = 0,
        size: Int = 10,
        completion: @escaping (Result<[NewsModel], NetworkError>) -> Void
    ) {
        guard let url = buildSearchURL(searchKeyword: searchKeyword, page: page, size: size) else {
            logError("Failed to build search URL")
            completion(.failure(.invalidURL))
            return
        }
        
        let request = createGETRequest(for: url)
        logRequest(request, description: "Searching news")
        
        performNetworkRequest(with: request, completion: completion)
    }
    
    /// 뉴스 원본 링크 조회
    func getNewsOriginalLink(
        for newsId: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        guard let url = buildLinkURL(for: newsId) else {
            logError("Failed to build link URL for newsId: \(newsId)")
            completion(.failure(.invalidURL))
            return
        }
        
        let request = createGETRequest(for: url)
        logLinkRequest(newsId: newsId, url: url)
        
        performLinkRequest(with: request, completion: completion)
    }
    
    // MARK: - methods (URL building)
    private func buildPaginatedNewsURL(page: Int, size: Int) -> URL? {
        guard var components = URLComponents(string: baseURL) else {
            logError("Invalid baseURL: \(baseURL)")
            return nil
        }
        
        components.path = "/api/exchange/news/paginated"
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(max(1, min(100, size)))) // 1-100 범위 제한
        ]
        
        guard let url = components.url else {
            logError("Failed to create paginated news URL from components")
            return nil
        }
        
        return url
    }
    
    private func buildSearchURL(searchKeyword: String, page: Int, size: Int) -> URL? {
        guard var components = URLComponents(string: baseURL) else {
            logError("Invalid baseURL: \(baseURL)")
            return nil
        }
        
        components.path = "/api/exchange/news/search"
        components.queryItems = [
            URLQueryItem(name: "searchKeyword", value: searchKeyword),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size))
        ]
        
        guard let url = components.url else {
            logError("Failed to create search URL from components")
            return nil
        }
        
        return url
    }
    
    private func buildLinkURL(for newsId: String) -> URL? {
        guard var components = URLComponents(string: baseURL) else {
            logError("Invalid baseURL: \(baseURL)")
            return nil
        }
        
        components.path = "/api/exchange/news/link/\(newsId)"
        
        guard let url = components.url else {
            logError("Failed to create link URL for newsId: \(newsId)")
            return nil
        }
        
        return url
    }
    
    // MARK: - methods (requesting)
    private func createGETRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func performPaginatedNewsRequest(
        with request: URLRequest,
        completion: @escaping (Result<NewsSearchResponse, NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                self.logError("Paginated news request error", error: error)
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logError("Invalid response type for paginated news")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            self.logResponseStatus(httpResponse.statusCode)
            
            guard let data = data else {
                self.logError("No data received for paginated news")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            self.processPaginatedNewsData(
                data: data,
                statusCode: httpResponse.statusCode,
                completion: completion
            )
        }.resume()
    }
    
    private func performNetworkRequest(
        with request: URLRequest,
        completion: @escaping (Result<[NewsModel], NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                self.logError("Search request error", error: error)
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logError("Invalid response type for search")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            self.logResponseStatus(httpResponse.statusCode)
            
            guard 200...299 ~= httpResponse.statusCode else {
                self.logError("HTTP error status code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                self.logError("No data received for search")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            self.processSearchNewsData(data: data, completion: completion)
        }.resume()
    }
    
    private func performLinkRequest(
        with request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                self.logError("Link request error", error: error)
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                self.logError("Link response error")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                self.logError("Link data parse error")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            self.processLinkData(data: data, completion: completion)
        }.resume()
    }
    
    // MARK: - methods (data processing)
    private func processPaginatedNewsData(
        data: Data,
        statusCode: Int,
        completion: @escaping (Result<NewsSearchResponse, NetworkError>) -> Void
    ) {
        do {
            let newsResponse = try JSONDecoder().decode(NewsSearchResponse.self, from: data)
            
            // 500 에러의 경우에도 성공적으로 디코딩되면 빈 응답으로 처리
            if statusCode == 500 && newsResponse.newsList.isEmpty {
                logSuccess("Received empty response (server error handled)")
            } else {
                logSuccess("Successfully parsed \(newsResponse.newsList.count) news items (page: \(newsResponse.currentPage))")
            }
            
            DispatchQueue.main.async {
                completion(.success(newsResponse))
            }
        } catch {
            logDecodingError(error: error, data: data)
            
            // 서버 에러 처리: 빈 응답 반환
            if statusCode >= 500 {
                let emptyResponse = NewsSearchResponse(
                    newsList: [],
                    currentPage: 0,
                    pageSize: 10,
                    totalCount: 0,
                    hasNext: false
                )
                DispatchQueue.main.async {
                    completion(.success(emptyResponse))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    private func processSearchNewsData(
        data: Data,
        completion: @escaping (Result<[NewsModel], NetworkError>) -> Void
    ) {
        do {
            let newsResponse = try JSONDecoder().decode(NewsSearchResponse.self, from: data)
            let newsModels = newsResponse.newsList.map { $0.toNewsModel() }
            
            logSuccess("Successfully parsed \(newsModels.count) search results")
            
            DispatchQueue.main.async {
                completion(.success(newsModels))
            }
        } catch {
            logDecodingError(error: error, data: data)
            DispatchQueue.main.async {
                completion(.failure(.decodingError))
            }
        }
    }
    
    private func processLinkData(
        data: Data,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        do {
            guard let linkResponse = try JSONSerialization.jsonObject(with: data) as? [String: String],
                  let originalLink = linkResponse["link"] else {
                logError("Link data parse error - invalid format")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            logSuccess("Successfully got original link")
            
            DispatchQueue.main.async {
                completion(.success(originalLink))
            }
        } catch {
            logError("Link JSON parse error", error: error)
            DispatchQueue.main.async {
                completion(.failure(.decodingError))
            }
        }
    }
    
    // MARK: - methods (logging)
    private func logRequest(_ request: URLRequest, description: String = "") {
        guard let url = request.url else {
            logError("Request URL is nil")
            return
        }
        
        print("🔍 [Network] \(description)")
        print("🔍 [Network] Request URL: \(url.absoluteString)")
        print("🔍 [Network] HTTP Method: \(request.httpMethod ?? "nil")")
    }
    
    private func logLinkRequest(newsId: String, url: URL) {
        print("🔍 [Network] Getting original link for newsId: \(newsId)")
        print("🔍 [Network] Request URL: \(url.absoluteString)")
    }
    
    private func logResponseStatus(_ statusCode: Int) {
        let emoji = statusCode < 400 ? "✅" : "⚠️"
        print("\(emoji) [Network] Response Status Code: \(statusCode)")
    }
    
    private func logSuccess(_ message: String) {
        print("✅ [Network] \(message)")
    }
    
    private func logError(_ message: String, error: Error? = nil) {
        if let error = error {
            print("❌ [Network] \(message): \(error.localizedDescription)")
        } else {
            print("❌ [Network] \(message)")
        }
    }
    
    private func logDecodingError(error: Error, data: Data) {
        print("❌ [Network] JSON Decoding Error: \(error)")
        print("🔍 [Network] Response Data Size: \(data.count) bytes")
        
        if let jsonString = String(data: data, encoding: .utf8) {
            let truncatedResponse = String(jsonString.prefix(1000))
            print("🔍 [Network] Raw Response (truncated): \(truncatedResponse)")
        }
    }
}

// MARK: - networking error models
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case noData
    case encodingError
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .invalidResponse:
            return "서버 응답 오류입니다."
        case .noData:
            return "데이터가 없습니다."
        case .encodingError:
            return "요청 데이터 인코딩 오류입니다."
        case .decodingError:
            return "응답 데이터 디코딩 오류입니다."
        }
    }
}
