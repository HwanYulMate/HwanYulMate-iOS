//
//  WithdrawlViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/5/25.
//

import UIKit
import IQKeyboardManagerSwift

final class WithdrawalViewController: UIViewController {
    
    // MARK: - properties
    private let withdrawalView = WithdrawalView()
    private var userName: String = "홍길동" // 추후 API에서 가져올 userName
    
    // MARK: - life Cycles
    override func loadView() {
        view = withdrawalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
        setupTextView()
        setupKeyboardManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - methods
    private func setupActions() {
        withdrawalView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        withdrawalView.cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        
        withdrawalView.withdrawButton.addTarget(
            self,
            action: #selector(withdrawButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupTextView() {
        withdrawalView.reasonTextView.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbar.items = [flexSpace, doneButton]
        withdrawalView.reasonTextView.inputAccessoryView = toolbar
    }
    
    private func setupKeyboardManager() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func withdrawButtonTapped() {
        // TODO: 탈퇴하기 API 연결
        print("탈퇴하기 버튼 선택 - API 호출 예정")
        print("탈퇴 이유: \(withdrawalView.reasonTextView.text ?? "")")
        
        // 임시: 탈퇴 처리 후 루트 뷰로 이동하는 로직
        performWithdrawalAPI()
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    private func performWithdrawalAPI() {
        let reason = withdrawalView.reasonTextView.text ?? ""
        // TODO: 실제 탈퇴 API 호출
        // WithdrawalAPI.withdraw(userName: userName, reason: reason) { [weak self] result in
        // }
    }
}

extension WithdrawalViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.count > 100 {
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        withdrawalView.updateCharCount(count)
    }
}
