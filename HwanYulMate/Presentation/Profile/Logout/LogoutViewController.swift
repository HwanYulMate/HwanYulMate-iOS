//
//  LogoutViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/4/25.
//

import UIKit
import RxSwift
import Alamofire
import GoogleSignIn

final class LogoutViewController: UIViewController {
    
    // MARK: - properties
    private let logoutView = LogoutView()
    private let disposeBag = DisposeBag()
    private let authRepository: AuthRepositoryImpl
    
    // MARK: - life cycles
    init(authRepository: AuthRepositoryImpl = AuthRepositoryImpl()) {
        self.authRepository = authRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.authRepository = AuthRepositoryImpl()
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = logoutView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupActions() {
        logoutView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        logoutView.cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        
        logoutView.confirmButton.addTarget(
            self,
            action: #selector(confirmButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        performCompleteLogout()
    }
    
    // MARK: - methods (logging out)
    private func performCompleteLogout() {
        print("🔍 [Logout] 완전 로그아웃 프로세스 시작")
        
        logoutView.confirmButton.isEnabled = false
        logoutView.confirmButton.setTitle("로그아웃 중...", for: .disabled)
        
        guard authRepository.isLoggedIn() else {
            print("🔍 [Logout] 이미 로그아웃 상태")
            navigateToMyTab()
            return
        }
        
        printCurrentTokenStatus()
        
        performServerLogout()
    }
    
    private func printCurrentTokenStatus() {
        let accessToken = UserDefaults.standard.string(forKey: "access")
        let refreshToken = UserDefaults.standard.string(forKey: "refresh")
        
        print("🔍 [Logout] 현재 토큰 상태:")
        print("   - Access Token (access): \(accessToken != nil ? "존재" : "없음")")
        print("   - Refresh Token (refresh): \(refreshToken != nil ? "존재" : "없음")")
        
        if let token = accessToken {
            print("   - Access Token 값: \(String(token.prefix(20)))...")
        }
    }
    
    private func performServerLogout() {
        ProfileNetworkService.shared.logout()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] message in
                    print("✅ [Logout] 서버 로그아웃 성공: \(message)")
                    self?.performCompleteLocalLogout()
                    self?.navigateToMyTab()
                },
                onFailure: { [weak self] error in
                    print("❌ [Logout] 서버 로그아웃 실패: \(error)")
                    self?.handleServerLogoutError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func handleServerLogoutError(_ error: Error) {
        print("❌ [Logout] 서버 로그아웃 실패 상세: \(error.localizedDescription)")
        
        /// AFError에서 상태 코드 추출하여 자동 처리
        if let afError = error as? AFError,
           case .responseValidationFailed(let reason) = afError,
           case .unacceptableStatusCode(let code) = reason {
            
            print("❌ [Logout] HTTP 상태 코드: \(code)")
            
            switch code {
            case 401, 403:
                /// 권한 문제 - 즉시 로컬 로그아웃 수행
                print("🔍 [Logout] 권한 문제 (코드: \(code))로 자동 로컬 로그아웃 수행")
                performCompleteLocalLogout()
                navigateToMyTab()
                return
                
            case 404:
                /// API 경로 문제 - 로컬 로그아웃으로 대체
                print("🔍 [Logout] API 경로 문제로 자동 로컬 로그아웃 수행")
                performCompleteLocalLogout()
                navigateToMyTab()
                return
                
            default:
                break
            }
        }
        
        /// 네트워크 에러나 기타 에러의 경우에만 사용자에게 선택권 제공
        restoreButtonState()
        
        let alert = UIAlertController(
            title: "로그아웃 오류",
            message: "서버 로그아웃에 실패했습니다.\n로컬 로그아웃을 수행하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { [weak self] _ in
            self?.performCompleteLogout()
        })
        
        alert.addAction(UIAlertAction(title: "로컬 로그아웃", style: .destructive) { [weak self] _ in
            print("🔍 [Logout] 사용자 선택: 로컬 로그아웃 수행")
            self?.performCompleteLocalLogout()
            self?.navigateToMyTab()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - methods (local logout)
    private func performCompleteLocalLogout() {
        print("🔍 [Logout] 완전한 로컬 데이터 정리 시작")
        
        let userDefaults = UserDefaults.standard
        
        /// 1. 토큰 및 사용자 정보 삭제
        userDefaults.removeObject(forKey: "access")
        userDefaults.removeObject(forKey: "refresh")
        userDefaults.removeObject(forKey: "name")
        userDefaults.removeObject(forKey: "email")
        userDefaults.removeObject(forKey: "provider")
        
        /// 2. UserInfoManager 캐시 정리
        UserInfoManager.shared.clearUserInfo()
        
        /// 3. 기타 가능한 키들도 정리 (안전장치)
        let possibleTokenKeys = [
            "accessToken", "access_token", "ACCESS_TOKEN",
            "refreshToken", "refresh_token", "REFRESH_TOKEN",
            "authToken", "auth_token", "AUTH_TOKEN",
            "token", "Token", "TOKEN"
        ]
        
        for key in possibleTokenKeys {
            userDefaults.removeObject(forKey: key)
        }
        
        /// 4. Google Sign-In 상태 정리
        clearGoogleSignInState()
        
        userDefaults.synchronize()
        
        /// 5. 삭제 후 상태 확인
        verifyLogoutCompletion()
        
        print("✅ [Logout] 완전한 로컬 데이터 정리 완료")
    }
    
    private func verifyLogoutCompletion() {
        print("🔍 [Logout] 로그아웃 완료 후 상태 검증:")
        
        let userDefaults = UserDefaults.standard
        let accessToken = userDefaults.string(forKey: "access")
        let refreshToken = userDefaults.string(forKey: "refresh")
        let userName = userDefaults.string(forKey: "name")
        let userEmail = userDefaults.string(forKey: "email")
        
        print("   - Access Token: \(accessToken != nil ? "❌ 남아있음" : "✅ 삭제됨")")
        print("   - Refresh Token: \(refreshToken != nil ? "❌ 남아있음" : "✅ 삭제됨")")
        print("   - User Name: \(userName != nil ? "❌ 남아있음" : "✅ 삭제됨")")
        print("   - User Email: \(userEmail != nil ? "❌ 남아있음" : "✅ 삭제됨")")
        print("   - AuthRepository.isLoggedIn(): \(authRepository.isLoggedIn() ? "❌ 여전히 로그인됨" : "✅ 로그아웃됨")")
    }
    
    private func clearGoogleSignInState() {
        GIDSignIn.sharedInstance.signOut()
        print("✅ [Logout] Google Sign-In 상태 정리 완료")
    }
    
    private func restoreButtonState() {
        logoutView.confirmButton.isEnabled = true
        logoutView.confirmButton.setTitle("로그아웃", for: .normal)
    }
    
    // MARK: - methods (navigation)
    private func navigateToMyTab() {
        print("🔍 [Logout] 마이 탭으로 이동")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let tabBarController = self.findTabBarController() {
                tabBarController.selectedIndex = 2 // 마이 탭 (tag: 2)
                
                /// 네비게이션 스택 초기화
                if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                    navigationController.popToRootViewController(animated: false)
                }
                
                print("✅ [Logout] 마이 탭으로 이동 완료")
            } else {
                print("❌ [Logout] TabBarController를 찾을 수 없음")
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func findTabBarController() -> UITabBarController? {
        if let tabBarController = self.tabBarController {
            return tabBarController
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = window.rootViewController as? UITabBarController {
            return tabBarController
        }
        
        return nil
    }
}
