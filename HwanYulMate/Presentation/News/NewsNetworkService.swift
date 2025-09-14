//
//  NewsNetworkService.swift
//  HwanYulMate
//
//  Created by HanJW on 9/12/25.
//

import Foundation

final class NewsNetworkService {
    static let shared = NewsNetworkService()
    
    private let baseURL: String
    private let session = URLSession.shared
    
    private init() {
        self.baseURL = Config.baseURL
    }
    
    // MARK: - Public Methods
    func searchNews(
        searchKeyword: String = "달러",
        page: Int = 0,
        size: Int = 10,
        completion: @escaping (Result<[NewsModel], NetworkError>) -> Void
    ) {
        guard let url = buildSearchURL(searchKeyword: searchKeyword, page: page, size: size) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = createGETRequest(for: url)
        logRequest(request)
        
        performNetworkRequest(with: request, completion: completion)
    }
    
    func getNewsOriginalLink(
        for newsId: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/api/exchange/news/link/\(newsId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = createGETRequest(for: url)
        logLinkRequest(newsId: newsId, url: url)
        
        performLinkRequest(with: request, completion: completion)
    }
    
    // MARK: - Private Methods
    private func buildSearchURL(searchKeyword: String, page: Int, size: Int) -> URL? {
        guard var components = URLComponents(string: "\(baseURL)/api/exchange/news/search") else {
            return nil
        }
        
        components.queryItems = [
            URLQueryItem(name: "searchKeyword", value: searchKeyword),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size))
        ]
        
        return components.url
    }
    
    private func createGETRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    private func performNetworkRequest(
        with request: URLRequest,
        completion: @escaping (Result<[NewsModel], NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                self.logError("Request Error", error: error)
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logError("Invalid Response Type")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            self.logResponseStatus(httpResponse.statusCode)
            
            guard 200...299 ~= httpResponse.statusCode else {
                self.logError("HTTP Error Status Code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                self.logError("No Data Received")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            self.processNewsData(data: data, completion: completion)
        }.resume()
    }
    
    private func processNewsData(
        data: Data,
        completion: @escaping (Result<[NewsModel], NetworkError>) -> Void
    ) {
        do {
            let newsResponse = try JSONDecoder().decode(NewsSearchResponse.self, from: data)
            let newsModels = newsResponse.newsList.map { $0.toNewsModel() }  // newsList 사용
            
            logSuccess("Successfully parsed \(newsModels.count) news items")
            
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
    
    private func performLinkRequest(
        with request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                self.logError("Link Request Error", error: error)
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                self.logError("Link Response Error")
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                self.logError("Link Data Parse Error")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            self.processLinkData(data: data, completion: completion)
        }.resume()
    }
    
    private func processLinkData(
        data: Data,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        do {
            guard let linkResponse = try JSONSerialization.jsonObject(with: data) as? [String: String],
                  let originalLink = linkResponse["link"] else {
                logError("Link Data Parse Error")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            logSuccess("Successfully got original link: \(originalLink)")
            
            DispatchQueue.main.async {
                completion(.success(originalLink))
            }
        } catch {
            logError("Link JSON Parse Error", error: error)
            DispatchQueue.main.async {
                completion(.failure(.decodingError))
            }
        }
    }
    
    // MARK: - Logging Methods
    private func logRequest(_ request: URLRequest) {
        print("🔍 [Network] Request URL:", request.url?.absoluteString ?? "nil")
        print("🔍 [Network] HTTP Method:", request.httpMethod ?? "nil")
    }
    
    private func logLinkRequest(newsId: String, url: URL) {
        print("🔍 [Network] Getting original link for newsId:", newsId)
        print("🔍 [Network] Request URL:", url.absoluteString)
    }
    
    private func logResponseStatus(_ statusCode: Int) {
        print("🔍 [Network] Response Status Code:", statusCode)
    }
    
    private func logSuccess(_ message: String) {
        print("✅ [Network]", message)
    }
    
    private func logError(_ message: String, error: Error? = nil) {
        if let error = error {
            print("❌ [Network]", message + ":", error.localizedDescription)
        } else {
            print("❌ [Network]", message)
        }
    }
    
    private func logDecodingError(error: Error, data: Data) {
        print("❌ [Network] JSON Decoding Error:", error)
        print("🔍 [Network] Response Data Size:", data.count, "bytes")
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🔍 [Network] Raw Response:", jsonString)
        }
    }
}

// MARK: - NetworkError
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
