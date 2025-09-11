//
//  HomeReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/30/25.
//

import Foundation
import ReactorKit

final class HomeReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case tapNotificationButton
        case tapCellItem(IndexPath)
    }
    
    enum Mutation {
        case setRoute(Route?)
    }
    
    struct State {
        var route: Route?
    }
    
    enum Route {
        case notification
        case homeDetail
    }
    
    // MARK: - properties
    let initialState = State()
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapNotificationButton:
            return .just(.setRoute(.notification))
        case .tapCellItem:
            return .just(.setRoute(.homeDetail))
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
