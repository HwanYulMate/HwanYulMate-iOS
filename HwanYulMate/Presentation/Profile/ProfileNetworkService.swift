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
    
    // MARK: - properties
    static let shared = ProfileNetworkService()
    
    var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            fatalError("BASE_URL not set in Info.plist")
        }
        return url
    }
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - methods
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
            print("🔍 [Logout] 로그아웃 프로세스 시작")
            
            guard let token = self.getAccessToken(), !token.isEmpty else {
                print("❌ [Network] 토큰이 없습니다")
                single(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))))
                return Disposables.create()
            }
            
            print("🔍 [Network] 토큰 길이: \(token.count) 문자")
            print("🔍 [Network] 토큰 앞 20자: \(String(token.prefix(20)))...")
            
            /// 토큰 유효성 검사
            if !self.isTokenValid(token) {
                print("❌ [Network] 토큰 유효성 검사 실패")
                single(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))))
                return Disposables.create()
            }
            
            let url = "\(self.baseURL)/api/auth/logout"
            let headers = self.getHeaders()
            
            print("🔍 [Network] 로그아웃 요청 정보:")
            print("   - URL: \(url)")
            print("   - Method: POST")
            print("   - Headers: \(headers)")
            
            AF.request(url,
                       method: .post,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                print("🔍 [Network] 로그아웃 응답:")
                
                if let httpResponse = response.response {
                    print("   - Status Code: \(httpResponse.statusCode)")
                    print("   - Response Headers: \(httpResponse.allHeaderFields)")
                }
                
                if let data = response.data {
                    print("   - Response Size: \(data.count) bytes")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("   - Response Body: \(responseString)")
                    }
                }
                
                if let error = response.error {
                    print("   - Error: \(error)")
                    print("   - Error Code: \(error._code)")
                    print("   - Error Domain: \(error._domain)")
                }
                
                /// 결과 처리
                switch response.result {
                case .success:
                    let message = String(data: response.data ?? Data(), encoding: .utf8) ?? "로그아웃 성공"
                    print("✅ [Network] 로그아웃 성공: \(message)")
                    single(.success(message))
                    
                case .failure(let error):
                    print("❌ [Network] 로그아웃 실패: \(error)")
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    // 탈퇴하기
    func withdrawAccount(reason: String? = nil) -> Single<String> {
        return Single.create { single in
            print("🔍 [Withdrawal] 회원탈퇴 API 호출")
            
            /// 토큰 존재 여부 확인
            guard let token = self.getAccessToken(), !token.isEmpty else {
                print("❌ [Withdrawal] 토큰이 없습니다")
                single(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))))
                return Disposables.create()
            }
            
            print("🔍 [Withdrawal] 토큰 확인: Bearer \(String(token.prefix(20)))...")
            
            /// 토큰 유효성 검사
            if !self.isTokenValid(token) {
                print("❌ [Withdrawal] 토큰이 유효하지 않음")
                single(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))))
                return Disposables.create()
            }
            
            let url = "\(self.baseURL)/api/auth/withdraw"
            
            /// 파라미터 준비
            var parameters: [String: String]? = nil
            if let reason = reason, !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                parameters = ["reason": reason]
                print("🔍 [Withdrawal] 탈퇴 사유 포함: \(reason)")
            } else {
                print("🔍 [Withdrawal] 탈퇴 사유 없음")
            }
            
            let headers = self.getHeaders()
            print("🔍 [Withdrawal] 요청 정보:")
            print("   - URL: \(url)")
            print("   - Method: DELETE")
            print("   - Parameters: \(parameters ?? [:])")
            print("   - Headers: \(headers)")
            
            AF.request(url,
                       method: .delete,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                print("🔍 [Withdrawal] 응답 정보:")
                
                if let httpResponse = response.response {
                    print("   - Status Code: \(httpResponse.statusCode)")
                    print("   - Response Headers: \(httpResponse.allHeaderFields)")
                }
                
                if let data = response.data {
                    print("   - Response Size: \(data.count) bytes")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("   - Response Body: \(responseString)")
                    }
                }
                
                if let error = response.error {
                    print("   - Error: \(error)")
                }
                
                /// 결과 처리
                switch response.result {
                case .success:
                    let message = String(data: response.data ?? Data(), encoding: .utf8) ?? "회원탈퇴가 완료되었습니다"
                    print("✅ [Withdrawal] 회원탈퇴 성공: \(message)")
                    single(.success(message))
                    
                case .failure(let error):
                    print("❌ [Withdrawal] 회원탈퇴 실패: \(error)")
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
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let token = UserDefaults.standard.string(forKey: "access") {
            headers["Authorization"] = "Bearer \(token)"
            print("🔍 [Network] 토큰 발견: Bearer \(String(token.prefix(10)))...")
        } else {
            print("❌ [Network] 토큰 없음 (키: 'access')")
        }
        
        return headers
    }
    
    private func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "access")
    }
    
    private func isTokenValid(_ token: String) -> Bool {
        /// JWT 토큰의 기본 구조 검사
        let components = token.components(separatedBy: ".")
        guard components.count == 3 else {
            print("❌ [Network] 토큰 형식 오류: JWT 구조가 아님")
            return false
        }
        
        /// Base64URL 디코딩을 위한 payload 부분 처리
        var payload = components[1]
        
        /// Base64URL에서 Base64로 변환 (패딩 추가)
        let missingPadding = payload.count % 4
        if missingPadding > 0 {
            payload += String(repeating: "=", count: 4 - missingPadding)
        }
        
        /// '-', '_' 문자를 Base64 표준 문자로 변환
        payload = payload
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        /// Base64 디코딩 시도
        guard let payloadData = Data(base64Encoded: payload) else {
            print("❌ [Network] 토큰 페이로드 디코딩 실패")
            return false
        }
        
        /// JSON 파싱 시도
        do {
            if let payloadJSON = try JSONSerialization.jsonObject(with: payloadData) as? [String: Any] {
                print("🔍 [Network] 토큰 페이로드: \(payloadJSON)")
                
                /// 만료 시간 체크 (exp 클레임)
                if let exp = payloadJSON["exp"] as? Double {
                    let expirationDate = Date(timeIntervalSince1970: exp)
                    let now = Date()
                    let timeUntilExpiration = expirationDate.timeIntervalSince(now)
                    
                    print("🔍 [Network] 토큰 만료 시간: \(expirationDate)")
                    print("🔍 [Network] 현재 시간: \(now)")
                    print("🔍 [Network] 만료까지 남은 시간: \(timeUntilExpiration)초")
                    
                    if timeUntilExpiration <= 0 {
                        print("❌ [Network] 토큰이 만료됨")
                        return false
                    } else if timeUntilExpiration <= 300 {
                        print("⚠️ [Network] 토큰이 곧 만료됨 (5분 이내)")
                    }
                }
                
                /// 발급자 확인 (iss 클레임)
                if let iss = payloadJSON["iss"] as? String {
                    print("🔍 [Network] 토큰 발급자: \(iss)")
                }
                
                /// 사용자 ID 확인 (sub 클레임)
                if let sub = payloadJSON["sub"] as? String {
                    print("🔍 [Network] 사용자 ID: \(sub)")
                }
                
            }
        } catch {
            print("⚠️ [Network] 토큰 페이로드 파싱 실패: \(error)")
            /// 파싱 실패해도 토큰 자체는 유효할 수 있으므로 true 반환
            /// 서버에서 최종 검증하도록 유지함
            return true
        }
        
        print("✅ [Network] 토큰 유효성 검사 통과")
        return true
    }
}

// MARK: - response models
struct UserInfoResponse: Codable {
    let email: String
    let userName: String
    let provider: String
    let createdAt: String
    let isDeleted: Bool?
    let deletedAt: String?
    let finalDeletionDate: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case userName
        case provider
        case createdAt
        case isDeleted
        case deletedAt
        case finalDeletionDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        userName = try container.decode(String.self, forKey: .userName)
        provider = try container.decode(String.self, forKey: .provider)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        
        /// isDeleted가 없거나 null인 경우 false로 기본값 설정
        isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        
        deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt)
        finalDeletionDate = try container.decodeIfPresent(String.self, forKey: .finalDeletionDate)
    }
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
