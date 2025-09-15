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
        
        homeView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.identifier)
        
        reactor?.action.onNext(.didLoadView)
        
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
        
        homeView.tableView.rx.itemSelected
            .map { HomeReactor.Action.tapCellItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .notification:
                    let notificationVC = NotificationViewController(reactor: NotificationReactor())
                    notificationVC.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(notificationVC, animated: true)
                case .homeDetail(let currencyCode):
                    let homeDetailVC = HomeDetailViewController()
                    homeDetailVC.reactor = HomeDetailReactor(currencyCode: currencyCode)
                    homeDetailVC.hidesBottomBarWhenPushed = true
                    owner.navigationController?.pushViewController(homeDetailVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.exchangeRates }
            .bind(
                to: homeView.tableView.rx.items(
                    cellIdentifier: HomeCell.identifier,
                    cellType: HomeCell.self
                )
            ) { (_, element, cell) in
                cell.bind(exchangeRate: element)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.baseDate }
            .bind(with: self) { owner, date in
                owner.homeView.bind(date: date)
            }
            .disposed(by: disposeBag)
    }
}
