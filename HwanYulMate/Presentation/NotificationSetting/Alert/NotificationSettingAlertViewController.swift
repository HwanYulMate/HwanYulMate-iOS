//
//  NotificationSettingAlertViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class NotificationSettingAlertViewController: UIViewController, View {
    
    // MARK: - properties
    private let notificationSettingAlertView = NotificationSettingAlertView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = notificationSettingAlertView
    }
    
    // MARK: - methods
    func bind(reactor: NotificationSettingAlertReactor) {
        notificationSettingAlertView.doneButton.rx.tap
            .map { NotificationSettingAlertReactor.Action.tapDoneButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .dismiss:
                    owner.dismiss(animated: false)
                }
            }
            .disposed(by: disposeBag)
    }
}
