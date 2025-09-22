//
//  UserInfoManager.swift
//  HwanYulMate
//
//  Created by HanJW on 9/18/25.
//

import Foundation
import RxSwift

final class UserInfoManager {
    
    // MARK: - properties
    static let shared = UserInfoManager()
    
    private let disposeBag = DisposeBag()
    private var cachedUserInfo: UserInfoResponse?
    
    private init() {}
    
    // MARK: - methods
    func getCachedUserInfo() -> UserInfoResponse? {
        return cachedUserInfo
    }
    
    func fetchUserInfo() -> Single<UserInfoResponse> {
        return ProfileNetworkService.shared.getUserInfo()
            .do(onSuccess: { [weak self] userInfo in
                self?.cachedUserInfo = userInfo
                self?.saveUserInfoToLocal(userInfo)
                print("✅ [UserInfo] 사용자 정보 업데이트: \(userInfo.email)")
            }, onError: { error in
                print("❌ [UserInfo] 사용자 정보 로드 실패: \(error)")
                
                /// DecodingError.keyNotFound 특별 처리
                if let decodingError = error as? DecodingError {
                    self.handleDecodingError(decodingError)
                }
            })
    }
    
    func loadUserInfoFromLocal() -> UserInfoResponse? {
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let userName = UserDefaults.standard.string(forKey: "name") else {
            return nil
        }
        
        let userInfo = UserInfoResponse(
            email: email,
            userName: userName,
            provider: UserDefaults.standard.string(forKey: "provider") ?? "unknown",
            createdAt: "",
            isDeleted: false,
            deletedAt: nil,
            finalDeletionDate: nil
        )
        
        cachedUserInfo = userInfo
        return userInfo
    }
    
    func getUserEmail() -> String {
        /// 1. 캐시된 정보에서 이메일 반환
        if let cachedEmail = cachedUserInfo?.email {
            return cachedEmail
        }
        
        /// 2. 로컬 저장소에서 이메일 반환
        if let localEmail = UserDefaults.standard.string(forKey: "email") {
            return localEmail
        }
        
        /// 3. 기본값 반환
        return "사용자"
    }
    
    func getUserName() -> String {
        if let cachedName = cachedUserInfo?.userName {
            return cachedName
        }
        
        if let localName = UserDefaults.standard.string(forKey: "name") {
            return localName
        }
        
        return "사용자"
    }
    
    private func saveUserInfoToLocal(_ userInfo: UserInfoResponse) {
        UserDefaults.standard.set(userInfo.email, forKey: "email")
        UserDefaults.standard.set(userInfo.userName, forKey: "name")
        UserDefaults.standard.set(userInfo.provider, forKey: "provider")
        UserDefaults.standard.synchronize()
    }
    
    private func handleDecodingError(_ error: DecodingError) {
        switch error {
        case .keyNotFound(let key, let context):
            print("❌ [UserInfo] JSON 키 누락: \(key.stringValue)")
            print("   - Context: \(context.debugDescription)")
            print("   - CodingPath: \(context.codingPath)")
            
            /// 특별한 키에 대한 처리
            if key.stringValue == "isDeleted" {
                print("🔧 [UserInfo] isDeleted 키 누락 - Optional 처리 권장")
            }
            
        case .typeMismatch(let type, let context):
            print("❌ [UserInfo] 타입 불일치: 예상 \(type)")
            print("   - Context: \(context.debugDescription)")
            
        case .valueNotFound(let type, let context):
            print("❌ [UserInfo] 값 없음: 예상 \(type)")
            print("   - Context: \(context.debugDescription)")
            
        case .dataCorrupted(let context):
            print("❌ [UserInfo] 데이터 손상")
            print("   - Context: \(context.debugDescription)")
            
        @unknown default:
            print("❌ [UserInfo] 알 수 없는 디코딩 에러: \(error)")
        }
    }
    
    func clearUserInfo() {
        cachedUserInfo = nil
        print("🧹 [UserInfo] 사용자 정보 캐시 정리 완료")
    }
}

extension UserInfoResponse {
    init(email: String, userName: String, provider: String, createdAt: String, isDeleted: Bool?, deletedAt: String?, finalDeletionDate: String?) {
        self.email = email
        self.userName = userName
        self.provider = provider
        self.createdAt = createdAt
        self.isDeleted = isDeleted
        self.deletedAt = deletedAt
        self.finalDeletionDate = finalDeletionDate
    }
}
