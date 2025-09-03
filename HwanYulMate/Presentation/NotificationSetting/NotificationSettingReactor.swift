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
