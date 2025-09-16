//
//  ProfileViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/1/25.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - properties
    private let profileView = ProfileView()
    
    private let profileSections: [ProfileSection] = [
        ProfileSection(
            title: "계정 정보",
            items: [
                ProfileItem(title: "Test@gmail.com", type: .email)
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
                ProfileItem(title: "앱버전", version: "2.1.2", type: .version)
            ]
        )
    ]
    
    // MARK: - life cycles
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - methods
    private func configureTableView() {
        profileView.tableView.register(
            ProfileCell.self,
            forCellReuseIdentifier: ProfileCell.identifier
        )
        
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }
    
    private func handleSelection(section: Int, row: Int) {
        let item = profileSections[section].items[row]
        
        switch (section, row) {
        case (1, 0):
            // 개인정보 처리방침
            let privacyPolicyVC = PrivacyPolicyViewController()
            navigationController?.pushViewController(privacyPolicyVC, animated: true)
            
        case (1, 1):
            // 오픈소스 라이선스
            let openSourceLicenseVC = OpenSourceLicenseViewController()
            navigationController?.pushViewController(openSourceLicenseVC, animated: true)
            
        case (2, 0):
            // 로그아웃
            let logoutVC = LogoutViewController()
            navigationController?.pushViewController(logoutVC, animated: true)
            
        case (2, 1):
            // 탈퇴하기
            let withdrawVC = WithdrawalViewController()
            navigationController?.pushViewController(withdrawVC, animated: true)
            
        case (2, 2):
            // 피드백 보내기
            presentFeedbackViewController()
            
        default:
            break
        }
    }
    
    private func presentFeedbackViewController() {
        let feedbackVC = FeedbackViewController()
        feedbackVC.modalPresentationStyle = .pageSheet
        feedbackVC.modalTransitionStyle = .coverVertical
        present(feedbackVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
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
            return UITableViewCell()
        }
        
        let item = profileSections[indexPath.section].items[indexPath.row]
        
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
            
        case .version:
            cell.configure(
                title: item.title,
                version: item.version,
                cellType: .version
            )
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
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

// MARK: - Data Models
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
