//
//  NotificationSettingReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/1/25.
//

import Foundation
import ReactorKit

final class NotificationSettingReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case tapBackBarButtonItem
        case tapAlarmSwitch
    }
    
    enum Mutation {
        case setRoute(Route)
    }
    
    struct State {
        var route: Route?
    }
    
    enum Route {
        case pop
        case targetRate
    }
    
    // MARK: - properties
    let initialState = State()
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapBackBarButtonItem:
            return .just(.setRoute(.pop))
        case .tapAlarmSwitch:
            return .just(.setRoute(.targetRate))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setRoute(route):
            newState.route = route
        }
        
        return newState
    }
}
