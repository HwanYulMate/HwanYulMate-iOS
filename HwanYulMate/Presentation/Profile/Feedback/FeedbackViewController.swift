//
//  FeedbackViewController.swift
//  HwanYulMate
//
//  Created by HanJW on 9/7/25.
//

import UIKit
import MessageUI

final class FeedbackViewController: UIViewController {
    
    // MARK: - properties
    private let recipientEmail = "gh7052@gmail.com"
    
    // MARK: - life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentMailComposer()
    }
    
    // MARK: - methods
    private func presentMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            showMailNotConfiguredAlert()
            return
        }
        
        let mailComposer = configureMailComposer()
        present(mailComposer, animated: true)
    }
    
    private func configureMailComposer() -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients([recipientEmail])
        
        mailComposer.setSubject("문의 사항")
        
        let messageBody = createMessageBody()
        mailComposer.setMessageBody(messageBody, isHTML: false)
        
        return mailComposer
    }
    
    private func createMessageBody() -> String {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        let deviceModel = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        
        let messageBody = """
        이곳에 내용을 작성해 주세요.
        
        
        =====================================
        Device OS : \(systemVersion)
        =====================================
        
        나의 iPhone에서 보냄
        
        앱 버전: \(appVersion) (\(buildNumber))
        기기: \(deviceModel)
        """
        
        return messageBody
    }
    
    private func showMailNotConfiguredAlert() {
        let alert = UIAlertController(
            title: "메일 설정 필요",
            message: "기기에 메일 계정이 설정되어 있지 않습니다.\n설정 앱에서 메일 계정을 추가해주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension FeedbackViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        var message: String = ""
        
        switch result {
        case .sent:
            message = "메일이 성공적으로 전송되었습니다."
        case .cancelled:
            message = "" // 취소 시에는 메시지 표시하지 않음
        case .failed:
            message = "메일 전송에 실패했습니다.\n다시 시도해주세요."
        case .saved:
            message = "메일이 임시보관함에 저장되었습니다."
        @unknown default:
            message = "알 수 없는 오류가 발생했습니다."
        }
        
        controller.dismiss(animated: true) { [weak self] in
            if !message.isEmpty {
                self?.showResultAlert(message: message)
            } else {
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func showResultAlert(message: String) {
        let alert = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
}
