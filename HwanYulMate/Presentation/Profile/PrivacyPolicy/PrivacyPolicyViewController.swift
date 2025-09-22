//
//  PrivacyPolicyViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/3/25.
//

import UIKit

final class PrivacyPolicyViewController: UIViewController {
    
    // MARK: - properties
    private let privacyPolicyView = PrivacyPolicyView()
    
    // MARK: - life cycles
    override func loadView() {
        view = privacyPolicyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    // MARK: - methods
    private func setupActions() {
        privacyPolicyView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
