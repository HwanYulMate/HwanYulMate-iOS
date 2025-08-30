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
        case .tapNotificationButton:
            return .empty()
        }
    }
}
