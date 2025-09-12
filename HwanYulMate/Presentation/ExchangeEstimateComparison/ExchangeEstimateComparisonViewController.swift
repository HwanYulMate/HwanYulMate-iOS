//
//  ExchangeEstimateComparisonViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/12/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class ExchangeEstimateComparisonViewController: UIViewController, View {
    
    // MARK: - properties
    private let exchangeEstimateComparisonView = ExchangeEstimateComparisonView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = exchangeEstimateComparisonView
    }
    
    // MARK: - methods
    func bind(reactor: ExchangeEstimateComparisonReactor) {
        exchangeEstimateComparisonView.backButton.rx.tap
            .map { ExchangeEstimateComparisonReactor.Action.tapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .dismiss:
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
