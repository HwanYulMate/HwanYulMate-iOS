//
//  HomeDetailViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import UIKit
import SafariServices
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
        
        reactor?.action.onNext(.didLoadView)
    }
    
    // MARK: - methods
    private func configureUI() {
        configureNavigation()
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
        
        homeDetailView.segmentedControl.rx.selectedSegmentIndex
            .distinctUntilChanged()
            .map { HomeDetailReactor.Action.tapSegmentedControl($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeDetailView.newsButton1.rx.tap
            .map { HomeDetailReactor.Action.tapNewsButton(0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeDetailView.newsButton2.rx.tap
            .map { HomeDetailReactor.Action.tapNewsButton(1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeDetailView.newsButton3.rx.tap
            .map { HomeDetailReactor.Action.tapNewsButton(2) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeDetailView.newsButton4.rx.tap
            .map { HomeDetailReactor.Action.tapNewsButton(3) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeDetailView.newsButton5.rx.tap
            .map { HomeDetailReactor.Action.tapNewsButton(4) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        homeDetailView.exchangeEstimateComparisonButton.rx.tap
            .map { HomeDetailReactor.Action.tapExchangeEstimateComparisonButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .bind(with: self) { owner, route in
                guard let route else { return }
                
                switch route {
                case .pop:
                    owner.navigationController?.popViewController(animated: true)
                case .news(let link):
                    guard let url = URL(string: link) else { return }
                    let safariVC = SFSafariViewController(url: url)
                    owner.present(safariVC, animated: true)
                case .bottomSheet:
                    let exchangeEstimateComparisonBottomSheetVC = ExchangeEstimateComparisonBottomSheetViewController()
                    exchangeEstimateComparisonBottomSheetVC.reactor = ExchangeEstimateComparisonBottomSheetReactor()
                    exchangeEstimateComparisonBottomSheetVC.modalPresentationStyle = .overFullScreen
                    owner.present(exchangeEstimateComparisonBottomSheetVC, animated: false)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.navigationTitle }
            .bind(with: self) { owner, navigationTitle in
                owner.homeDetailView.bind(navigationTitle: navigationTitle)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.exchangeRate }
            .bind(with: self) { owner, exchangeRate in
                owner.homeDetailView.bind(exchangeRate: exchangeRate)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.chart }
            .bind(with: self) { owner, chart in
                owner.homeDetailView.bind(chart: chart)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.exchangeRateChangeTitle }
            .bind(with: self) { owner, exchangeRateChangeTitle in
                owner.homeDetailView.bind(exchangeRateChangeTitle: exchangeRateChangeTitle)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.news }
            .bind(with: self) { owner, news in
                owner.homeDetailView.bind(news: news)
            }
            .disposed(by: disposeBag)
    }
}
