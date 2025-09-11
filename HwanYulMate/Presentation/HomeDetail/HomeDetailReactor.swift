//
//  HomeDetailReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import Foundation
import ReactorKit

final class HomeDetailReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case tapBackBarButtonItem
    }
    
    enum Mutation {
        case setRoute(Route?)
    }
    
    struct State {
        var route: Route?
    }
    
    enum Route {
        case pop
    }
    
    // MARK: - properties
    let initialState = State()
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapBackBarButtonItem:
            return .just(.setRoute(.pop))
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
