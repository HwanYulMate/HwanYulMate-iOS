//
//  WithdrawlViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/5/25.
//

import UIKit
import IQKeyboardManagerSwift
import RxSwift
import GoogleSignIn
import Alamofire

final class WithdrawalViewController: UIViewController {
    
    // MARK: - properties
    private let withdrawalView = WithdrawalView()
    private let disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = withdrawalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
        setupTextView()
        setupKeyboardManager()
        loadUserNameFromAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - methods (setting up)
    private func setupActions() {
        withdrawalView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        withdrawalView.cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        
        withdrawalView.withdrawButton.addTarget(
            self,
            action: #selector(withdrawButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupTextView() {
        withdrawalView.reasonTextView.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbar.items = [flexSpace, doneButton]
        withdrawalView.reasonTextView.inputAccessoryView = toolbar
    }
    
    private func setupKeyboardManager() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
    private func loadUserNameFromAPI() {
        print("🔍 [Withdrawal] 사용자 이름 로드 시작")
        
        /// 1차: UserInfoManager 캐시에서 확인
        if let cachedUserInfo = UserInfoManager.shared.getCachedUserInfo() {
            print("✅ [Withdrawal] 캐시에서 사용자 이름 발견: \(cachedUserInfo.userName)")
            withdrawalView.updateUserName(cachedUserInfo.userName)
            return
        }
        
        /// 2차: UserDefaults에서 확인
        let localUserName = UserInfoManager.shared.getUserName()
        if !localUserName.isEmpty {
            print("✅ [Withdrawal] 로컬에서 사용자 이름 발견: \(localUserName)")
            withdrawalView.updateUserName(localUserName)
            return
        }
        
        /// 3차: API에서 가져오기
        print("🔍 [Withdrawal] API에서 사용자 정보 가져오는 중...")
        UserInfoManager.shared.fetchUserInfo()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] userInfo in
                    print("✅ [Withdrawal] API에서 사용자 정보 성공: \(userInfo.userName)")
                    self?.withdrawalView.updateUserName(userInfo.userName)
                },
                onFailure: { [weak self] error in
                    print("❌ [Withdrawal] 사용자 정보 로드 실패: \(error)")
                    // 실패 시에도 기본 텍스트로 표시
                    self?.withdrawalView.updateUserName("")
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - methods (action)
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func withdrawButtonTapped() {
        showWithdrawalConfirmation()
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    private func showWithdrawalConfirmation() {
        let alert = UIAlertController(
            title: "회원탈퇴",
            message: "정말로 탈퇴하시겠습니까?\n탈퇴 후에는 모든 데이터가 삭제되며 복구할 수 없습니다.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "탈퇴", style: .destructive) { [weak self] _ in
            self?.performWithdrawalAPI()
        })
        
        present(alert, animated: true)
    }
    
    private func performWithdrawalAPI() {
        print("🔍 [Withdrawal] 회원탈퇴 API 호출 시작")
        
        withdrawalView.withdrawButton.isEnabled = false
        
        let reason = withdrawalView.reasonTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        print("🔍 [Withdrawal] 탈퇴 사유: \(reason ?? "없음")")
        
        /// 현재 토큰 상태 확인
        let accessToken = UserDefaults.standard.string(forKey: "access")
        print("🔍 [Withdrawal] Access Token 상태: \(accessToken != nil ? "존재 (길이: \(accessToken!.count))" : "없음")")
        
        ProfileNetworkService.shared.withdrawAccount(reason: reason)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] message in
                    print("✅ [Withdrawal] API 성공: \(message)")
                    self?.handleWithdrawalSuccess(message: message)
                },
                onFailure: { [weak self] error in
                    print("❌ [Withdrawal] API 실패: \(error)")
                    print("❌ [Withdrawal] 에러 타입: \(type(of: error))")
                    self?.handleWithdrawalError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func handleWithdrawalSuccess(message: String) {
        print("✅ [Withdrawal] 회원탈퇴 성공: \(message)")
        
        /// 모든 토큰 및 사용자 데이터 삭제
        let userDefaults = UserDefaults.standard
        
        /// AuthLocalDataSource와 동일한 키 사용
        userDefaults.removeObject(forKey: "access")
        userDefaults.removeObject(forKey: "refresh")
        userDefaults.removeObject(forKey: "name")
        userDefaults.removeObject(forKey: "email")
        userDefaults.removeObject(forKey: "provider")
        
        /// UserInfoManager 캐시 정리
        UserInfoManager.shared.clearUserInfo()
        
        /// 기타 가능한 키들도 정리 (안전장치)
        let possibleKeys = [
            "accessToken", "access_token", "ACCESS_TOKEN",
            "refreshToken", "refresh_token", "REFRESH_TOKEN",
            "isLoggedIn", "user_id", "userId"
        ]
        
        for key in possibleKeys {
            userDefaults.removeObject(forKey: key)
        }
        
        userDefaults.synchronize()
        
        GIDSignIn.sharedInstance.signOut()
        
        print("✅ [Withdrawal] 로컬 데이터 정리 완료")
        
        let alert = UIAlertController(
            title: "탈퇴 처리 완료",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            /// 마이 탭으로 이동
            self?.navigateToMyTab()
        })
        present(alert, animated: true)
    }
    
    // MARK: - methods (navigation)
    private func navigateToMyTab() {
        print("🔍 [Withdrawal] 마이 탭으로 이동")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let tabBarController = self.findTabBarController() {
                tabBarController.selectedIndex = 2 // 마이 탭 (tag: 2)
                
                if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                    navigationController.popToRootViewController(animated: false)
                }
                
                print("✅ [Withdrawal] 마이 탭으로 이동 완료")
            } else {
                print("❌ [Withdrawal] TabBarController를 찾을 수 없음")
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
    
    // MARK: - methods (error handling)
    private func handleWithdrawalError(_ error: Error) {
        withdrawalView.withdrawButton.isEnabled = true
        
        print("❌ [Withdrawal] 에러 상세 분석:")
        print("   - Error: \(error)")
        print("   - LocalizedDescription: \(error.localizedDescription)")
        
        /// Alamofire 에러 분석
        if let afError = error as? AFError {
            print("   - AFError Type: \(afError)")
            
            switch afError {
            case .responseValidationFailed(let reason):
                switch reason {
                case .unacceptableStatusCode(let code):
                    print("   - HTTP Status Code: \(code)")
                    handleHTTPError(statusCode: code)
                    return
                default:
                    print("   - Validation Failed: \(reason)")
                }
                
            case .sessionTaskFailed(let sessionError):
                print("   - Session Error: \(sessionError)")
                if let urlError = sessionError as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        showNetworkErrorAlert()
                        return
                    case .timedOut:
                        showTimeoutErrorAlert()
                        return
                    default:
                        break
                    }
                }
                
            default:
                print("   - Other AFError: \(afError)")
            }
        }
        
        showGenericWithdrawalError(error)
    }
    
    private func handleHTTPError(statusCode: Int) {
        switch statusCode {
        case 401:
            showTokenExpiredAlert()
        case 403:
            showPermissionDeniedAlert()
        case 404:
            showAPINotFoundAlert()
        case 400:
            showBadRequestAlert()
        case 500...599:
            showServerErrorAlert()
        default:
            showGenericWithdrawalError(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode)))
        }
    }

    private func showTokenExpiredAlert() {
        let alert = UIAlertController(
            title: "인증 만료",
            message: "로그인이 만료되었습니다.\n마이 탭으로 이동합니다.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigateToMyTab()
        })
        
        present(alert, animated: true)
    }

    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "권한 오류",
            message: "회원탈퇴 권한이 없습니다.\n마이 탭으로 이동합니다.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigateToMyTab()
        })
        
        present(alert, animated: true)
    }

    private func showAPINotFoundAlert() {
        let alert = UIAlertController(
            title: "서비스 오류",
            message: "탈퇴 서비스를 찾을 수 없습니다.\n잠시 후 다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true)
    }

    private func showBadRequestAlert() {
        let alert = UIAlertController(
            title: "탈퇴 처리 안내",
            message: "이미 탈퇴 처리 중인 계정일 수 있습니다.\n\n• 30일 내 재가입한 경우 이전 탈퇴 처리가 유지됩니다\n• 로그아웃을 원하시면 '로그아웃'을 선택해주세요",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            self?.navigateToLogoutScreen()
        })
        
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { [weak self] _ in
            self?.performWithdrawalAPI()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }

    private func navigateToLogoutScreen() {
        let logoutVC = LogoutViewController()
        navigationController?.pushViewController(logoutVC, animated: true)
    }

    private func showServerErrorAlert() {
        let alert = UIAlertController(
            title: "서버 오류",
            message: "서버에 일시적인 문제가 발생했습니다.\n잠시 후 다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { [weak self] _ in
            self?.performWithdrawalAPI()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }

    private func showNetworkErrorAlert() {
        let alert = UIAlertController(
            title: "네트워크 오류",
            message: "인터넷 연결을 확인하고 다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { [weak self] _ in
            self?.performWithdrawalAPI()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }

    private func showTimeoutErrorAlert() {
        let alert = UIAlertController(
            title: "요청 시간 초과",
            message: "서버 응답이 지연되고 있습니다.\n다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { [weak self] _ in
            self?.performWithdrawalAPI()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }

    private func showGenericWithdrawalError(_ error: Error) {
        let alert = UIAlertController(
            title: "탈퇴 실패",
            message: "회원탈퇴 중 오류가 발생했습니다.\n(\(error.localizedDescription))\n\n다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { [weak self] _ in
            self?.performWithdrawalAPI()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension WithdrawalViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.count > 100 {
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        withdrawalView.updateCharCount(count)
    }
}
