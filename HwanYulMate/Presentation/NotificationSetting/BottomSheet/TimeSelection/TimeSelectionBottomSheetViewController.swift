//
//  TimeSelectionBottomSheetViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/8/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class TimeSelectionBottomSheetViewController: UIViewController, View {
    
    // MARK: - properties
    private let timeSelectionBottomSheetView = TimeSelectionBottomSheetView()
    
    var disposeBag = DisposeBag()
    
    let resultRelay = PublishRelay<DailyAlert?>()
    
    // MARK: - life cycles
    override func loadView() {
        view = timeSelectionBottomSheetView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reactor?.action.onNext(.didAppearView)
    }
    
    // MARK: - methods
    func bind(reactor: TimeSelectionBottomSheetReactor) {
        timeSelectionBottomSheetView.selectButton1.rx.tap
            .map { TimeSelectionBottomSheetReactor.Action.tapSelectButton(0, "09:00") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        timeSelectionBottomSheetView.selectButton2.rx.tap
            .map { TimeSelectionBottomSheetReactor.Action.tapSelectButton(1, "12:00") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        timeSelectionBottomSheetView.selectButton3.rx.tap
            .map { TimeSelectionBottomSheetReactor.Action.tapSelectButton(2, "14:00") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        timeSelectionBottomSheetView.selectButton4.rx.tap
            .map { TimeSelectionBottomSheetReactor.Action.tapSelectButton(3, "16:00") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        timeSelectionBottomSheetView.leadingButton.rx.tap
            .map { TimeSelectionBottomSheetReactor.Action.tapLeadingButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        timeSelectionBottomSheetView.trailingButton.rx.tap
            .map { TimeSelectionBottomSheetReactor.Action.tapTrailingButton(reactor.currentState.selectedButton) }
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
            .map { $0.selectedButtonIndex }
            .bind(with: self) { owner, selectedButtonIndex in
                owner.timeSelectionBottomSheetView.bind(selectedButtonIndex: selectedButtonIndex)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.containerBottomConstraint }
            .distinctUntilChanged()
            .bind(with: self) { owner, constraint in
                UIView.animate(withDuration: 0.3) {
                    owner.timeSelectionBottomSheetView.containerBottomConstraint?.update(offset: constraint)
                    owner.view.layoutIfNeeded()
                } completion: { completion in
                    if constraint == 385 && completion {
                        if let dailyAlert = reactor.currentState.dailyAlert {
                            owner.resultRelay.accept(dailyAlert)
                        } else {
                            owner.resultRelay.accept(nil)
                        }
                        
                        owner.dismiss(animated: false)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.containerHeightConstraint }
            .bind(with: self) { owner, constraint in
                owner.timeSelectionBottomSheetView.containerHeightConstraint?.update(offset: constraint)
            }
            .disposed(by: disposeBag)
    }
}
