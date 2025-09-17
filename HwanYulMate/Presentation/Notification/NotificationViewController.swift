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
    override func loadView() {
        view = notificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        reactor?.action.onNext(.didLoadView)
    }
    
    // MARK: - methods
    private func configureUI() {
        configureTableView()
        configureNavigation()
    }
    
    private func configureTableView() {
        notificationView.tableView.register(
            NotificationHeaderView.self,
            forHeaderFooterViewReuseIdentifier: NotificationHeaderView.identifier
        )
        
        notificationView.tableView.register(
            NotificationCell.self,
            forCellReuseIdentifier: NotificationCell.identifier
        )
        
        notificationView.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func configureNavigation() {
        navigationItem.titleView = notificationView.navigationTitleLabel
        navigationItem.leftBarButtonItem = notificationView.backBarButtonItem
    }
    
    func bind(reactor: NotificationReactor) {
        notificationView.backBarButtonItem.rx.tap
            .map { NotificationReactor.Action.tapBackBarButtonItem }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        notificationView.tableView.rx.itemSelected
            .map { NotificationReactor.Action.tapCellItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .pop:
                    owner.navigationController?.popViewController(animated: true)
                case .notificationSetting(let currencyCode):
                    let notificationSettingViewController = NotificationSettingViewController()
                    notificationSettingViewController.reactor = NotificationSettingReactor(currencyCode: currencyCode)
                    owner.navigationController?.pushViewController(notificationSettingViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.alertSettings }
            .bind(
                to: notificationView.tableView.rx.items(
                    cellIdentifier: NotificationCell.identifier,
                    cellType: NotificationCell.self
                )
            ) { (_, element, cell) in
                cell.bind(alertSetting: element)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - extensions
extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NotificationHeaderView.identifier
        ) as? NotificationHeaderView else { return UITableViewHeaderFooterView() }
        
        return headerView
    }
}
