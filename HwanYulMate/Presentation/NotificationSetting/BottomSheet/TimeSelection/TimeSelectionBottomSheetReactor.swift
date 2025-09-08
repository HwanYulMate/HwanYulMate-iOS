//
//  TimeSelectionBottomSheetReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/8/25.
//

import Foundation
import ReactorKit

final class TimeSelectionBottomSheetReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case didAppearView
    }
    
    enum Mutation {
        case setContainerHeightConstraint(Float)
        case updateContainerBottomConstraint(Float)
    }
    
    struct State {
        var route: Route?
        var containerBottomConstraint: Float = 385
        var containerHeightConstraint: Float = 385
    }
    
    enum Route {
        case dismiss
    }
    
    // MARK: - properties
    let initialState = State()
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didAppearView:
            return .merge(
                .just(.setContainerHeightConstraint(385)),
                .just(.updateContainerBottomConstraint(0.0))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setContainerHeightConstraint(let constraint):
            newState.containerHeightConstraint = constraint
        case .updateContainerBottomConstraint(let constraint):
            newState.containerBottomConstraint = constraint
        }
        
        return newState
    }
}
