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
            .map { _ in NotificationSettingReactor.Action.tapAlarmSwitch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        notificationSettingView.scheduleSwitch.rx.isOn
            .changed
            .map { _ in NotificationSettingReactor.Action.tapScheduleSwitch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .pop:
                    owner.navigationController?.popViewController(animated: true)
                case .targetRate:
                    let targetRateBottomSheetViewController = TargetRateBottomSheetViewController()
                    targetRateBottomSheetViewController.reactor = TargetRateBottomSheetReactor()
                    targetRateBottomSheetViewController.modalPresentationStyle = .overFullScreen
                    owner.present(targetRateBottomSheetViewController, animated: false)
                case .timeSelection:
                    let timeSelectionBottomSheetViewController = TimeSelectionBottomSheetViewController()
                    timeSelectionBottomSheetViewController.reactor = TimeSelectionBottomSheetReactor()
                    timeSelectionBottomSheetViewController.modalPresentationStyle = .overFullScreen
                    owner.present(timeSelectionBottomSheetViewController, animated: false)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.alertSetting }
            .bind(with: self) { owner, alertSetting in
                owner.notificationSettingView.bind(alertSetting: alertSetting)
            }
            .disposed(by: disposeBag)
    }
}
