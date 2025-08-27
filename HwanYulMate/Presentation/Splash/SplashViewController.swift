//
//  SplashViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/26/25.
//

import UIKit
import RxCocoa
import RxSwift

final class SplashViewController: UIViewController {
    
    // MARK: - properties
    private let splashView = SplashView()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveToMainAfterDelay()
    }
    
    // MARK: - methods
    private func moveToMainAfterDelay() {
        Observable<Int>
            .timer(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { _, _ in
                let tabBarViewController = TabBarViewController()
                
                if let windowScene = UIApplication.shared
                    .connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = tabBarViewController
                    window.makeKeyAndVisible()
                }
            }
            .disposed(by: disposeBag)
    }
}
