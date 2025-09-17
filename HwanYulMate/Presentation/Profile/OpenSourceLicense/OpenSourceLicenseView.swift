//
//  OpenSourceLicenseViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/3/25.
//

import UIKit

final class OpenSourceLicenseViewController: UIViewController {
    
    // MARK: - properties
    private let openSourceLicenseView = OpenSourceLicenseView()
    
    // MARK: - life Cycles
    override func loadView() {
        view = openSourceLicenseView
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
        openSourceLicenseView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
