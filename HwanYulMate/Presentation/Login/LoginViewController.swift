//
//  LoginViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/26/25.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - properties
    private let loginView = LoginView()
    
    // MARK: - life cycles
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
    }
}
