//
//  TimeSelectionBottomSheetViewController.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/8/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class TimeSelectionBottomSheetViewController: UIViewController, View {
    
    // MARK: - properties
    private let timeSelectionBottomSheetView = TimeSelectionBottomSheetView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - life cycles
    override func loadView() {
        view = timeSelectionBottomSheetView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reactor?.action.onNext(.didAppearView)
    }
    
    // MARK: - methods
    func bind(reactor: TimeSelectionBottomSheetReactor) {
        reactor.state
            .map { $0.containerBottomConstraint }
            .distinctUntilChanged()
            .bind(with: self) { owner, constraint in
                UIView.animate(withDuration: 0.3) {
                    owner.timeSelectionBottomSheetView.containerBottomConstraint?.update(offset: constraint)
                    owner.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.containerHeightConstraint }
            .bind(with: self) { owner, constraint in
                owner.timeSelectionBottomSheetView.containerHeightConstraint?.update(offset: constraint)
            }
            .disposed(by: disposeBag)
    }
}
