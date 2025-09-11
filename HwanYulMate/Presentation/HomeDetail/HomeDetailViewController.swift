//
//  HomeDetailViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class HomeDetailViewController: UIViewController, View {
    
    // MARK: - properties
    private let homeDetailView = HomeDetailView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = homeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - methods
    private func configureUI() {
        configureTableView()
        configureNavigation()
    }
    
    private func configureTableView() {
        homeDetailView.tableView.register(
            HomeDetailCell.self,
            forCellReuseIdentifier: HomeDetailCell.identifier
        )
    }
    
    private func configureNavigation() {
        navigationItem.titleView = homeDetailView.navigationTitleLabel
        navigationItem.leftBarButtonItem = homeDetailView.backBarButtonItem
    }
    
    func bind(reactor: HomeDetailReactor) {
        homeDetailView.backBarButtonItem.rx.tap
            .map { HomeDetailReactor.Action.tapBackBarButtonItem }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .pop:
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
