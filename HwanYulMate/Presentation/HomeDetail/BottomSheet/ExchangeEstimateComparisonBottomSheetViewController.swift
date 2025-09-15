//
//  ExchangeEstimateComparisonBottomSheetViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/11/25.
//

import UIKit
import IQKeyboardManagerSwift
import ReactorKit
import RxCocoa
import RxSwift

final class ExchangeEstimateComparisonBottomSheetViewController: UIViewController, View {
    
    // MARK: - properties
    private let exchangeEstimateComparisonBottomSheetView = ExchangeEstimateComparisonBottomSheetView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = exchangeEstimateComparisonBottomSheetView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.willAppearView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reactor?.action.onNext(.willDisappearView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reactor?.action.onNext(.didAppearView)
    }
    
    // MARK: - methods
    func bind(reactor: ExchangeEstimateComparisonBottomSheetReactor) {
        exchangeEstimateComparisonBottomSheetView.leadingButton.rx.tap
            .map { ExchangeEstimateComparisonBottomSheetReactor.Action.tapLeadingButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        exchangeEstimateComparisonBottomSheetView.trailingButton.rx.tap
            .map { ExchangeEstimateComparisonBottomSheetReactor.Action.tapTrailingButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .exchangeEstimateComparison(let currencyCode, let exchangeRate):
                    let exchangeEstimateComparisonVC = ExchangeEstimateComparisonViewController()
                    exchangeEstimateComparisonVC.reactor = ExchangeEstimateComparisonReactor(currencyCode: currencyCode, exchangeRate: exchangeRate)
                    exchangeEstimateComparisonVC.modalPresentationStyle = .fullScreen
                    owner.present(exchangeEstimateComparisonVC, animated: true)
                case .dismiss:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.keyboardDistance }
            .bind { distance in
                IQKeyboardManager.shared.keyboardDistance = distance
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.containerBottomConstraint }
            .distinctUntilChanged()
            .bind(with: self) { owner, constraint in
                UIView.animate(withDuration: 0.3) {
                    owner.exchangeEstimateComparisonBottomSheetView.containerBottomConstraint?.update(offset: constraint)
                    owner.view.layoutIfNeeded()
                } completion: { completion in
                    if constraint == 290 && completion {
                        owner.dismiss(animated: false)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.containerHeightConstraint }
            .bind(with: self) { owner, constraint in
                owner.exchangeEstimateComparisonBottomSheetView.containerHeightConstraint?.update(offset: constraint)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.currencyCode },
            reactor.state.map { $0.exchangeRate }
        )
        .map { "1 \($0.0) = \($0.1.toCurrencyString())" }
        .bind(with: self) { owner, exchangeRate in
            owner.exchangeEstimateComparisonBottomSheetView.bind(exchangeRate: exchangeRate)
        }
        .disposed(by: disposeBag)
    }
}
