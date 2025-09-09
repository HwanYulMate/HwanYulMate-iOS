//
//  NotificationSettingAlertReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import Foundation
import ReactorKit

final class NotificationSettingAlertReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case tapDoneButton
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
        case .tapDoneButton:
            return .just(.setRoute(.dismiss))
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
