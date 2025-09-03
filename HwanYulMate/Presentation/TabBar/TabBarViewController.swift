//
//  TabBarViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/25/25.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarController()
        configureTabBarAppearence()
    }
    
    // MARK: - methods
    private func configureTabBarController() {
        let homeVC = UINavigationController(rootViewController: HomeViewController(reactor: HomeReactor()))
        homeVC.tabBarItem = UITabBarItem(title: "환율", image: .exchangeRate, tag: 0)
        
        setViewControllers([homeVC], animated: true)
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
