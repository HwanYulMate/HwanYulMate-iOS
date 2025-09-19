//
//  LoginReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation
import ReactorKit

final class LoginReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case tapBackButton
        case tapGoogleLoginButton
        case tapAppleLoginButton
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setUser(User?)
    }
    
    struct State {
        var route: Route?
    }
    
    enum Route {
        case dismiss
    }
    
    // MARK: - properties
    let initialState = State()
    
    private var authRepository: AuthRepository
    
    // MARK: - life cycles
    init() {
        authRepository = AuthRepositoryImpl()
    }
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapBackButton:
            return .just(.setRoute(.dismiss))
        case .tapGoogleLoginButton:
            return authRepository.socialLogin(provider: .google)
                .asObservable()
                .map { Mutation.setUser($0) }
        case .tapAppleLoginButton:
            return authRepository.socialLogin(provider: .apple)
                .asObservable()
                .map { Mutation.setUser($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRoute(let route):
            newState.route = route
        case .setUser:
            newState.route = .dismiss
        }
        
        return newState
    }
}
