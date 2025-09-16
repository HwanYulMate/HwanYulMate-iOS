//
//  ProfileNetworkService.swift
//  HwanYulMate
//
//  Created by HanJW on 9/14/25.
//

import UIKit
import Alamofire
import RxSwift

final class ProfileNetworkService {
    
    static let shared = ProfileNetworkService()
    
    var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL not set in Info.plist")
        }
        return url
    }
    private let session = URLSession.shared
    
    private init() {}
    
    // 계정 정보
    func getUserInfo() -> Single<UserInfoResponse> {
        return Single.create { single in
            let url = "\(self.baseURL)/api/auth/profile"
            
            AF.request(url,
                       method: .get,
                       headers: self.getHeaders())
            .validate()
            .responseDecodable(of: UserInfoResponse.self) { response in
                switch response.result {
                case .success(let userInfo):
                    single(.success(userInfo))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    // 로그아웃
    func logout() -> Single<String> {
        return Single.create { single in
            let url = "\(self.baseURL)/api/auth/logout"
            
            AF.request(url,
                       method: .post,
                       headers: self.getHeaders())
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let message):
                    single(.success(message))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    // 탈퇴하기
    func withdrawAccount(reason: String? = nil) -> Single<String> {
        return Single.create { single in
            let url = "\(self.baseURL)/api/auth/withdraw"
            
            var parameters: [String: String]? = nil
            if let reason = reason, !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                parameters = ["reason": reason]
            }
            
            AF.request(url,
                       method: .delete,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: self.getHeaders())
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let message):
                    single(.success(message))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    // 피드백 보내기
    func sendFeedback(type: FeedbackType, content: String) -> Single<String> {
        return Single.create { single in
            let url = "\(self.baseURL)/api/feedback"
            
            let deviceInfo = "\(UIDevice.current.model), iOS \(UIDevice.current.systemVersion)"
            let parameters: [String: String] = [
                "type": type.rawValue,
                "content": content,
                "deviceInfo": deviceInfo
            ]
            
            AF.request(url,
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: self.getHeaders())
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let message):
                    single(.success(message))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getFeedbackTypes() -> Single<[String: String]> {
        return Single.create { single in
            let url = "\(self.baseURL)/api/feedback/types"
            
            AF.request(url,
                       method: .get,
                       headers: self.getHeaders())
            .validate()
            .responseDecodable(of: [String: String].self) { response in
                switch response.result {
                case .success(let types):
                    single(.success(types))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - methods
    private func getHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        // TODO: 실제 토큰 추가
        // if let token = UserDefaults.standard.string(forKey: "accessToken") {
        //     headers["Authorization"] = "Bearer \(token)"
        // }
        
        return headers
    }
}

// MARK: - response models
struct UserInfoResponse: Codable {
    let email: String
    let userName: String
    let provider: String
    let createdAt: String
    let isDeleted: Bool
    let deletedAt: String?
    let finalDeletionDate: String?
}

enum FeedbackType: String, CaseIterable {
    case bug = "bug"
    case suggestion = "suggestion"
    case question = "question"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .bug:
            return "버그 신고"
        case .suggestion:
            return "기능 제안"
        case .question:
            return "문의사항"
        case .other:
            return "기타 피드백"
        }
    }
}
