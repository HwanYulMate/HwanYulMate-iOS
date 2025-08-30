//
//  HomeViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/24/25.
//

import UIKit
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController {
    
    // MARK: - properties
    private let homeView = HomeView()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - life cycles
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
}
