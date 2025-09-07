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
    }
    
    enum Mutation {
        case updateKeyboardDistance(CGFloat)
        case updateContainerBottomConstraint(Float)
    }
    
    struct State {
        var keyboardDistance: CGFloat = 10
        var containerBottomConstraint: Float = 290
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateKeyboardDistance(let distance):
            newState.keyboardDistance = distance
        case .updateContainerBottomConstraint(let constraint):
            newState.containerBottomConstraint = constraint
        }
        
        return newState
    }
}
