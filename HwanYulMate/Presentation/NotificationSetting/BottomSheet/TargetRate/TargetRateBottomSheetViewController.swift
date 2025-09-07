//
//  TargetRateBottomSheetViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/4/25.
//

import UIKit
import IQKeyboardManagerSwift
import ReactorKit
import RxCocoa
import RxSwift

final class TargetRateBottomSheetViewController: UIViewController, View {
    
    // MARK: - properties
    private let targetRateBottomSheetView = TargetRateBottomSheetView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = targetRateBottomSheetView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.willAppearView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reactor?.action.onNext(.willDisappearView)
    }
    
    // MARK: - methods
    func bind(reactor: TargetRateBottomSheetReactor) {
        reactor.state
            .map { $0.keyboardDistance }
            .bind { distance in
                IQKeyboardManager.shared.keyboardDistance = distance
            }
            .disposed(by: disposeBag)
    }
}
