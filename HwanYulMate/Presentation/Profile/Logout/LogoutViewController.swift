//
//  LogoutViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/4/25.
//

import UIKit

final class LogoutViewController: UIViewController {
    
    // MARK: - properties
    private let logoutView = LogoutView()
    
    // MARK: - life Cycles
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
    
    // MARK: - methods
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
        // TODO: 로그아웃 API 연결
        print("로그아웃 확인 버튼 선택 - API 호출 예정")
        
        // 임시: 로그아웃 처리 후 루트 뷰로 이동하는 로직
        navigationController?.popToRootViewController(animated: true)
    }
}
