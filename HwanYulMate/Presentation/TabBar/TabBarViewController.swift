//
//  TabBarViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/25/25.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarController()
        configureTabBarAppearence()
        
        delegate = self
    }
    
    // MARK: - methods
    private func configureTabBarController() {
        let homeVC = UINavigationController(rootViewController: HomeViewController(reactor: HomeReactor()))
        homeVC.tabBarItem = UITabBarItem(title: "환율", image: .exchangeRate, tag: 0)
        
        let newsVC = UINavigationController(rootViewController: NewsViewController())
        newsVC.tabBarItem = UITabBarItem(title: "뉴스", image: .news, tag: 1)
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "마이", image: .profile, tag: 2)
        
        setViewControllers([homeVC, newsVC, profileVC], animated: true)
    }
    
    private func configureTabBarAppearence() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.iconColor = .gray400
        appearance.stackedLayoutAppearance.selected.iconColor = .green500
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray400]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.green500]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.tag == 2 {
            
            if !authRepository.isLoggedIn() {
                print("🔍 [TabBar] 비로그인 상태로 마이 탭 선택 - 로그인 화면 표시")
                presentLoginScreen()
                return false
            }
        }
        
        return true
    }
    
    private func presentLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.reactor = LoginReactor()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}
