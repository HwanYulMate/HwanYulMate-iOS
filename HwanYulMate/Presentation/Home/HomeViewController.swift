//
//  HomeViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/24/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController, View {
    
    // MARK: - properties
    private let homeView = HomeView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    init(reactor: HomeReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.tableView.rx.contentOffset
            .map { $0.y }
            .bind(with: self) { owner, offset in
                var newHeight = owner.homeView.maxHeaderHeight - offset
                newHeight = max(owner.homeView.minHeaderHeight, newHeight)
                owner.homeView.headerHeightConstraint?.update(offset: newHeight)
                
                let progress = (newHeight - owner.homeView.minHeaderHeight) /
                (owner.homeView.maxHeaderHeight - owner.homeView.minHeaderHeight)
                owner.homeView.titleLabel.alpha = progress
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - methods
    func bind(reactor: HomeReactor) {
        homeView.notificationSettingButton.rx.tap
            .map { HomeReactor.Action.tapNotificationButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.action
            .filter { $0 == .tapNotificationButton }
            .bind(with: self) { owner, _ in
                let notificationVC = NotificationViewController()
                notificationVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(notificationVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
