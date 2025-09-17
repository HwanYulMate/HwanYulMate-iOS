//
//  LogoutViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/4/25.
//

import UIKit
import RxSwift

final class LogoutViewController: UIViewController {
    
    // MARK: - properties
    private let logoutView = LogoutView()
    private let disposeBag = DisposeBag()
    
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
        performLogout()
    }
    
    private func performLogout() {
        logoutView.confirmButton.isEnabled = false
        
        ProfileNetworkService.shared.logout()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] message in
                    self?.handleLogoutSuccess(message: message)
                },
                onFailure: { [weak self] error in
                    self?.handleLogoutError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func handleLogoutSuccess(message: String) {
        // TODO: 토큰 삭제 등 로그아웃 처리
        // UserDefaults.standard.removeObject(forKey: "accessToken")
        
        print("로그아웃 응답: \(message)")
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func handleLogoutError(_ error: Error) {
        logoutView.confirmButton.isEnabled = true
        
        let alert = UIAlertController(
            title: "로그아웃 실패",
            message: "로그아웃 중 오류가 발생했습니다. 다시 시도해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
