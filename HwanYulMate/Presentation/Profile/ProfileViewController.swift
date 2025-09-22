//
//  ProfileViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/1/25.
//

import UIKit
import RxSwift

final class ProfileViewController: UIViewController {
    
    // MARK: - properties
    private let profileView = ProfileView()
    private let disposeBag = DisposeBag()
    private let authRepository: AuthRepositoryImpl
    
    private var profileSections: [ProfileSection] = []
    private var isUserLoggedIn: Bool = false
    
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
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        print("🔄 [Profile] viewWillAppear - 로그인 상태 체크 및 UI 업데이트")
        
        /// 로그인 상태 체크 및 UI 업데이트 (필요한 경우에만 다시 로드)
        checkLoginStatusAndUpdateUIIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - methods (setting up)
    private func configureTableView() {
        profileView.tableView.register(
            ProfileCell.self,
            forCellReuseIdentifier: ProfileCell.identifier
        )
        
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }
    
    private func setupInitialData() {
        checkLoginStatusAndUpdateUIIfNeeded()
    }
    
    // MARK: - methods (login status managing)
    private func checkLoginStatusAndUpdateUIIfNeeded() {
        let previousLoginState = isUserLoggedIn
        isUserLoggedIn = authRepository.isLoggedIn()
        
        print("🔍 [Profile] 로그인 상태 변화 확인:")
        print("   - 이전 상태: \(previousLoginState)")
        print("   - 현재 상태: \(isUserLoggedIn)")
        
        /// 로그인 상태가 변경된 경우만 UI 업데이트
        if previousLoginState != isUserLoggedIn {
            print("🔄 [Profile] 로그인 상태 변경됨 - UI 업데이트 수행")
            
            if isUserLoggedIn {
                setupLoggedInUserData()
            } else {
                setupLoggedOutUserData()
            }
        } else {
            print("📱 [Profile] 로그인 상태 동일 - UI 업데이트 생략")
            
            /// 상태가 동일하더라도 로그인된 상태라면 사용자 정보 갱신
            if isUserLoggedIn {
                fetchUserInfoFromServer()
            }
        }
    }
    
    private func setupLoggedInUserData() {
        /// 로그인된 사용자: 기존 로직 사용
        UserInfoManager.shared.loadUserInfoFromLocal()
        updateProfileSectionsForLoggedInUser()
        
        /// 서버에서 최신 정보 가져오기
        fetchUserInfoFromServer()
    }
    
    private func setupLoggedOutUserData() {
        /// 로그아웃된 사용자: 제한된 UI 표시
        updateProfileSectionsForLoggedOutUser()
    }
    
    private func fetchUserInfoFromServer() {
        UserInfoManager.shared.fetchUserInfo()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] userInfo in
                    print("✅ [Profile] 사용자 정보 로드 성공: \(userInfo.email)")
                    self?.updateProfileSectionsForLoggedInUser()
                },
                onFailure: { [weak self] error in
                    print("❌ [Profile] 사용자 정보 로드 실패: \(error)")
                    /// 실패해도 로컬 정보로 계속 진행
                    self?.updateProfileSectionsForLoggedInUser()
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - methods (UI updating)
    private func updateProfileSectionsForLoggedInUser() {
        let userEmail = UserInfoManager.shared.getUserEmail()
        let appVersion = getAppVersion()
        
        profileSections = [
            ProfileSection(
                title: "계정 정보",
                items: [
                    ProfileItem(title: userEmail, type: .email)
                ]
            ),
            ProfileSection(
                title: "서비스 이용약관",
                items: [
                    ProfileItem(title: "개인정보 처리방침", type: .normal),
                    ProfileItem(title: "오픈소스 라이선스", type: .normal)
                ]
            ),
            ProfileSection(
                title: "설정",
                items: [
                    ProfileItem(title: "로그아웃", type: .normal),
                    ProfileItem(title: "탈퇴하기", type: .normal),
                    ProfileItem(title: "피드백 보내기", type: .normal),
                    ProfileItem(title: "앱버전", version: appVersion, type: .version)
                ]
            )
        ]
        
        reloadTableView()
    }
    
    private func updateProfileSectionsForLoggedOutUser() {
        let appVersion = getAppVersion()
        
        profileSections = [
            ProfileSection(
                title: "계정 정보",
                items: [
                    ProfileItem(title: "로그인 화면으로 이동", type: .loginLink)
                ]
            ),
            ProfileSection(
                title: "서비스 이용약관",
                items: [
                    ProfileItem(title: "개인정보 처리방침", type: .normal),
                    ProfileItem(title: "오픈소스 라이선스", type: .normal)
                ]
            ),
            ProfileSection(
                title: "설정",
                items: [
                    ProfileItem(title: "피드백 보내기", type: .normal),
                    ProfileItem(title: "앱버전", version: appVersion, type: .version)
                ]
            )
        ]
        
        reloadTableView()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.profileView.tableView.reloadData()
        }
    }
    
    // MARK: - methods (navigation)
    private func navigateToLoginScreen() {
        print("🔍 [Profile] 로그인 화면으로 이동")
        
        let loginVC = LoginViewController()
        loginVC.reactor = LoginReactor()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    private func handleSelection(section: Int, row: Int) {
        let item = profileSections[section].items[row]
        
        if item.type == .loginLink {
            navigateToLoginScreen()
            return
        }
        
        if item.type == .version {
            print("🔍 [Profile] 앱버전 셀은 선택할 수 없습니다")
            return
        }
        
        /// 로그아웃 상태에서 로그인 전용 기능 접근 시 로그인 화면으로 이동
        if !isUserLoggedIn && isLoginRequiredFeature(section: section, row: row) {
            showLoginRequiredAlert()
            return
        }
        
        switch (section, row) {
        case (1, 0):
            /// 개인정보 처리방침
            let privacyPolicyVC = PrivacyPolicyViewController()
            navigationController?.pushViewController(privacyPolicyVC, animated: true)
            
        case (1, 1):
            /// 오픈소스 라이선스
            let openSourceLicenseVC = OpenSourceLicenseViewController()
            navigationController?.pushViewController(openSourceLicenseVC, animated: true)
            
        case (2, 0) where isUserLoggedIn:
            /// 로그아웃 (로그인된 사용자만)
            let logoutVC = LogoutViewController()
            navigationController?.pushViewController(logoutVC, animated: true)
            
        case (2, 1) where isUserLoggedIn:
            /// 탈퇴하기 (로그인된 사용자만)
            let withdrawVC = WithdrawalViewController()
            navigationController?.pushViewController(withdrawVC, animated: true)
            
        case (2, 2) where isUserLoggedIn, (2, 0) where !isUserLoggedIn:
            /// 피드백 보내기 (로그인 상태와 관계없이 가능)
            presentFeedbackViewController()
            
        default:
            break
        }
    }
    
    private func isLoginRequiredFeature(section: Int, row: Int) -> Bool {
        /// 로그인이 필요한 기능들 정의
        switch (section, row) {
        case (2, 0), (2, 1): /// 로그아웃, 탈퇴하기
            return true
        default:
            return false
        }
    }
    
    private func showLoginRequiredAlert() {
        let alert = UIAlertController(
            title: "로그인 필요",
            message: "해당 기능을 사용하려면 로그인하세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "로그인", style: .default) { [weak self] _ in
            self?.navigateToLoginScreen()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func presentFeedbackViewController() {
        let feedbackVC = FeedbackViewController()
        feedbackVC.modalPresentationStyle = .pageSheet
        feedbackVC.modalTransitionStyle = .coverVertical
        present(feedbackVC, animated: true)
    }
    
    // 앱 버전 정보
    private func getAppVersion() -> String {
        let version = "1.0.0"
        
        return version
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return profileSections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileCell.identifier,
            for: indexPath
        ) as? ProfileCell else {
            print("❌ [Profile] ProfileCell 생성 실패")
            return UITableViewCell()
        }
        
        let item = profileSections[indexPath.section].items[indexPath.row]
        
        print("🔧 [Profile] 셀 구성 시작: [\(indexPath.section),\(indexPath.row)] \(item.title) (타입: \(item.type))")
        
        switch item.type {
        case .normal:
            cell.configure(
                title: item.title,
                showChevron: true,
                cellType: .normal
            )
            
        case .email:
            cell.configure(
                title: item.title,
                cellType: .email
            )
            
        case .loginLink:
            cell.configure(
                title: item.title,
                cellType: .loginLink
            )
            
        case .version:
            cell.configure(
                title: item.title,
                version: item.version,
                cellType: .version
            )
        }
        
        print("✅ [Profile] 셀 구성 완료: [\(indexPath.section),\(indexPath.row)] \(item.title)")
        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 32 : 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 75 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        
        let footerView = UIView()
        
        let dividerView = UIView().then {
            $0.backgroundColor = .divider
        }
        
        footerView.addSubview(dividerView)
        
        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(10)
            $0.top.equalToSuperview().offset(32)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = .pretendard(size: 12, weight: .semibold)
            header.textLabel?.textColor = .gray900
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleSelection(section: indexPath.section, row: indexPath.row)
    }
}

// MARK: - data models
struct ProfileSection {
    let title: String
    let items: [ProfileItem]
}

struct ProfileItem {
    let title: String
    let version: String?
    let type: ProfileCellType
    
    init(title: String, version: String? = nil, type: ProfileCellType) {
        self.title = title
        self.version = version
        self.type = type
    }
}
