//
//  WithdrawlViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/5/25.

import UIKit
import IQKeyboardManagerSwift
import RxSwift

final class WithdrawalViewController: UIViewController {
    
    // MARK: - properties
    private let withdrawalView = WithdrawalView()
    private let disposeBag = DisposeBag()
    private var userName: String = "홍길동"
    
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
        showWithdrawalConfirmation()
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    private func showWithdrawalConfirmation() {
        let alert = UIAlertController(
            title: "회원탈퇴",
            message: "정말로 탈퇴하시겠습니까?\n탈퇴 후에는 모든 데이터가 삭제되며 복구할 수 없습니다.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "탈퇴", style: .destructive) { [weak self] _ in
            self?.performWithdrawalAPI()
        })
        
        present(alert, animated: true)
    }
    
    private func performWithdrawalAPI() {
        withdrawalView.withdrawButton.isEnabled = false
        
        let reason = withdrawalView.reasonTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        ProfileNetworkService.shared.withdrawAccount(reason: reason)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] message in
                    self?.handleWithdrawalSuccess(message: message)
                },
                onFailure: { [weak self] error in
                    self?.handleWithdrawalError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func handleWithdrawalSuccess(message: String) {
        // TODO: 토큰 삭제 등 탈퇴 처리
        // UserDefaults.standard.removeObject(forKey: "accessToken")
        
        let alert = UIAlertController(
            title: "탈퇴 처리 완료",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func handleWithdrawalError(_ error: Error) {
        withdrawalView.withdrawButton.isEnabled = true
        
        let alert = UIAlertController(
            title: "탈퇴 실패",
            message: "회원탈퇴 중 오류가 발생했습니다. 다시 시도해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
