//
//  TargetRateBottomSheetReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/4/25.
//

import Foundation
import ReactorKit

final class TargetRateBottomSheetReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case willAppearView
        case willDisappearView
        case didAppearView
        case tapLeadingButton
        case tapTrailingButton(String)
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setContainerHeightConstraint(Float)
        case setTargetPrice(TargetPrice)
        case updateKeyboardDistance(CGFloat)
        case updateContainerBottomConstraint(Float)
    }
    
    struct State {
        var route: Route?
        var keyboardDistance: CGFloat = 10
        var containerBottomConstraint: Float = 290
        var containerHeightConstraint: Float = 290
        var currencyCode: String = ""
        var targetPrice: TargetPrice?
    }
    
    enum Route {
        case dismiss
        case alert
    }
    
    // MARK: - properties
    let initialState: State
    
    private let alertSettingsRepository: AlertSettingsRepository
    
    // MARK: - life cycles
    init(currencyCode: String) {
        self.initialState = State(currencyCode: currencyCode)
        self.alertSettingsRepository = AlertSettingsRepositoryImpl()
    }
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .willAppearView:
            return .just(.updateKeyboardDistance(50))
        case .willDisappearView:
            return .just(.updateKeyboardDistance(10))
        case .didAppearView:
            return .merge(
                .just(.setContainerHeightConstraint(290)),
                .just(.updateContainerBottomConstraint(0.0))
            )
        case .tapLeadingButton:
            return .merge(
                .just(.updateKeyboardDistance(10)),
                .just(.updateContainerBottomConstraint(290))
            )
        case .tapTrailingButton(let targetRateString):
            if let targetRate = Double(targetRateString), targetRate > 0 {
                let targetPrice = alertSettingsRepository
                    .enableTargetPriceAlert(
                        currencyCode: currentState.currencyCode,
                        targetPrice: targetRate,
                        condition: "ABOVE"
                    )
                    .asObservable()
                    .map { Mutation.setTargetPrice($0) }
                
                return .concat(
                    targetPrice,
                    .just(.setRoute(.alert)),
                    .just(.updateKeyboardDistance(10)),
                    .just(.setRoute(nil)),
                )
            } else {
                return .just(.setRoute(nil))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRoute(let route):
            newState.route = route
        case .setContainerHeightConstraint(let constraint):
            newState.containerHeightConstraint = constraint
        case .setTargetPrice(let targetPrice):
            if targetPrice.success {
                newState.targetPrice = targetPrice
                newState.route = .alert
                newState.route = nil
            }
        case .updateKeyboardDistance(let distance):
            newState.keyboardDistance = distance
        case .updateContainerBottomConstraint(let constraint):
            newState.containerBottomConstraint = constraint
        }
        
        return newState
    }
}
