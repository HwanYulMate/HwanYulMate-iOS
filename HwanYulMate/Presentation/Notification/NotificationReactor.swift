//
//  NotificationReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/30/25.
//

import Foundation
import ReactorKit

final class NotificationReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case tapBackBarButtonItem
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    // MARK: - properties
    let initialState = State()
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapBackBarButtonItem:
            return .empty()
        }
    }
}
