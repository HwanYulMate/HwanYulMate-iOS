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
        case tapTrailingButton
    }
    
    enum Mutation {
        case updateKeyboardDistance(CGFloat)
        case updateContainerBottomConstraint(Float)
        case setRoute(Route)
    }
    
    struct State {
        var keyboardDistance: CGFloat = 10
        var containerBottomConstraint: Float = 290
        var route: Route?
    }
    
    enum Route {
        case dismiss
    }
    
    // MARK: - properties
    let initialState = State()
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .willAppearView:
            return .just(.updateKeyboardDistance(50))
        case .willDisappearView:
            return .just(.updateKeyboardDistance(10))
        case .didAppearView:
            return .just(.updateContainerBottomConstraint(0.0))
        case .tapLeadingButton:
            return .merge(
                .just(.updateKeyboardDistance(10)),
                .just(.updateContainerBottomConstraint(290)),
            )
        case .tapTrailingButton:
            return .just(.setRoute(.dismiss))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateKeyboardDistance(let distance):
            newState.keyboardDistance = distance
        case .updateContainerBottomConstraint(let constraint):
            newState.containerBottomConstraint = constraint
        case .setRoute(let route):
            newState.route = route
        }
        
        return newState
    }
}
