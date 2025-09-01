//
//  NotificationViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/30/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class NotificationViewController: UIViewController, View {
    
    // MARK: - properties
    private let notificationView = NotificationView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    init(reactor: NotificationReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = notificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - methods
    private func configureUI() {
        navigationItem.titleView = notificationView.navigationTitleLabel
        navigationItem.leftBarButtonItem = notificationView.backBarButtonItem
    }
    
    func bind(reactor: NotificationReactor) {
        notificationView.backBarButtonItem.rx.tap
            .map { NotificationReactor.Action.tapBackBarButtonItem }
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
