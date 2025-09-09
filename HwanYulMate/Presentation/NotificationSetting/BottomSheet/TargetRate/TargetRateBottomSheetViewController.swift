//
//  TargetRateBottomSheetViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/4/25.
//

import UIKit
import IQKeyboardManagerSwift
import ReactorKit
import RxCocoa
import RxSwift

final class TargetRateBottomSheetViewController: UIViewController, View {
    
    // MARK: - properties
    private let targetRateBottomSheetView = TargetRateBottomSheetView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = targetRateBottomSheetView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.willAppearView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reactor?.action.onNext(.willDisappearView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reactor?.action.onNext(.didAppearView)
    }
    
    // MARK: - methods
    func bind(reactor: TargetRateBottomSheetReactor) {
        targetRateBottomSheetView.leadingButton.rx.tap
            .map { TargetRateBottomSheetReactor.Action.tapLeadingButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        targetRateBottomSheetView.trailingButton.rx.tap
            .map { TargetRateBottomSheetReactor.Action.tapTrailingButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .alert:
                    let notificationSettingAlertViewController = NotificationSettingAlertViewController()
                    notificationSettingAlertViewController.reactor = NotificationSettingAlertReactor()
                    notificationSettingAlertViewController.modalPresentationStyle = .overFullScreen
                    owner.present(notificationSettingAlertViewController, animated: false)
                case .dismiss:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.keyboardDistance }
            .bind { distance in
                IQKeyboardManager.shared.keyboardDistance = distance
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.containerBottomConstraint }
            .distinctUntilChanged()
            .bind(with: self) { owner, constraint in
                UIView.animate(withDuration: 0.3) {
                    owner.targetRateBottomSheetView.containerBottomConstraint?.update(offset: constraint)
                    owner.view.layoutIfNeeded()
                } completion: { completion in
                    if constraint == 290 && completion {
                        owner.dismiss(animated: false)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.containerHeightConstraint }
            .bind(with: self) { owner, constraint in
                owner.targetRateBottomSheetView.containerHeightConstraint?.update(offset: constraint)
            }
            .disposed(by: disposeBag)
    }
}
