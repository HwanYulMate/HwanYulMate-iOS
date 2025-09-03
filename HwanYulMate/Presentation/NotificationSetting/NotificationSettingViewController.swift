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
    init(reactor: NotificationSettingReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        reactor.action
            .filter { $0 == .tapBackBarButtonItem }
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
