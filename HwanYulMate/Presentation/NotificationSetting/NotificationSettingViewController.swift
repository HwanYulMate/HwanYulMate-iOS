//
//  NotificationSettingViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/30/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class NotificationSettingViewController: UIViewController, View {
    
    // MARK: - properties
    private let notificationSettingView = NotificationSettingView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = notificationSettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        reactor?.action.onNext(.didLoadView)
    }
    
    // MARK: - methods
    private func configureUI() {
        configureNavigation()
    }
    
    private func configureNavigation() {
        navigationItem.titleView = notificationSettingView.navigationTitleLabel
        navigationItem.leftBarButtonItem = notificationSettingView.backBarButtonItem
    }
    
    func bind(reactor: NotificationSettingReactor) {
        notificationSettingView.backBarButtonItem.rx.tap
            .map { NotificationSettingReactor.Action.tapBackBarButtonItem }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        notificationSettingView.alarmSwitch.rx.isOn
            .changed
            .map { NotificationSettingReactor.Action.tapAlarmSwitch($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        notificationSettingView.scheduleSwitch.rx.isOn
            .changed
            .map { NotificationSettingReactor.Action.tapScheduleSwitch($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .pop:
                    owner.navigationController?.popViewController(animated: true)
                case .targetRate(let currencyCode):
                    let targetRateBottomSheetVC = TargetRateBottomSheetViewController()
                    targetRateBottomSheetVC.reactor = TargetRateBottomSheetReactor(currencyCode: currencyCode)
                    targetRateBottomSheetVC.modalPresentationStyle = .overFullScreen
                    targetRateBottomSheetVC.resultRelay
                        .take(1)
                        .map { NotificationSettingReactor.Action.applyTargetRate($0) }
                        .bind(to: reactor.action)
                        .disposed(by: owner.disposeBag)
                    owner.present(targetRateBottomSheetVC, animated: false)
                case .timeSelection(let currencyCode):
                    let timeSelectionBottomSheetVC = TimeSelectionBottomSheetViewController()
                    timeSelectionBottomSheetVC.reactor = TimeSelectionBottomSheetReactor(currencyCode: currencyCode)
                    timeSelectionBottomSheetVC.modalPresentationStyle = .overFullScreen
                    timeSelectionBottomSheetVC.resultRelay
                        .take(1)
                        .map { NotificationSettingReactor.Action.applyDailyAlert($0) }
                        .bind(to: reactor.action)
                        .disposed(by: owner.disposeBag)
                    owner.present(timeSelectionBottomSheetVC, animated: false)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.alertSetting }
            .bind(with: self) { owner, alertSetting in
                owner.notificationSettingView.bind(alertSetting: alertSetting)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isAlarmSwitchOn }
            .bind(with: self) { owner, isAlarmSwitchOn in
                owner.notificationSettingView.bind(isAlarmSwitchOn: isAlarmSwitchOn)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isScheduleSwitchOn }
            .bind(with: self) { owner, isScheduleSwitchOn in
                owner.notificationSettingView.bind(isScheduleSwitchOn: isScheduleSwitchOn)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.navigationTitle }
            .bind(with: self) { owner, navigationTitle in
                owner.notificationSettingView.bind(navigationTitle: navigationTitle)
            }
            .disposed(by: disposeBag)
    }
}
