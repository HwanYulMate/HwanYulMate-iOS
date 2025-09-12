//
//  ExchangeEstimateComparisonReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/12/25.
//

import Foundation
import ReactorKit

final class ExchangeEstimateComparisonReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case tapBackButton
    }
    
    enum Mutation {
        case setRoute(Route?)
    }
    
    struct State {
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
        case .tapBackButton:
            return .concat(
                .just(.setRoute(.dismiss)),
                .just(.setRoute(nil)),
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRoute(let route):
            newState.route = route
        }
        
        return newState
    }
}
