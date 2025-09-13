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
        case didLoadView
        case tapNotificationButton
        case tapCellItem(IndexPath)
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setExchangeRates([ExchangeRate])
    }
    
    struct State {
        var route: Route?
        var exchangeRates: [ExchangeRate] = []
        var baseDate: String = ""
    }
    
    enum Route {
        case notification
        case homeDetail
    }
    
    // MARK: - properties
    let initialState = State()
    
    private let repository: ExchangeRateRepository
    
    // MARK: - life cycles
    init() {
        self.repository = ExchangeRateRepositoryImpl()
    }
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didLoadView:
            return repository.fetchAllExchangeRates()
                .asObservable()
                .map { Mutation.setExchangeRates($0) }
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
        case .setExchangeRates(let exchangeRates):
            newState.exchangeRates = exchangeRates
            newState.baseDate = exchangeRates.first?.baseDate ?? ""
        }
        
        return newState
    }
}
