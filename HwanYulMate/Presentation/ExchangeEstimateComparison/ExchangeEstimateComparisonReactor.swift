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
        case didLoadView
        case tapBackButton
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setBanks([Bank])
    }
    
    struct State {
        var route: Route?
        var currencyCode: String = ""
        var exchangeEstimateComparison: Double = 0.0
        var banks: [Bank] = []
    }
    
    enum Route {
        case dismiss
    }
    
    // MARK: - properties
    let initialState: State
    
    private let repository: BankRepository
    
    // MARK: - life cycles
    init(currencyCode: String, exchangeEstimateComparison: Double) {
        self.initialState = State(currencyCode: currencyCode, exchangeEstimateComparison: exchangeEstimateComparison)
        self.repository = BankRepositoryImpl()
    }
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didLoadView:
            return repository.fetchAllBankExchangeInfos(
                currencyCode: currentState.currencyCode,
                exchangeEstimateComparison: currentState.exchangeEstimateComparison
            )
            .asObservable()
            .map { Mutation.setBanks($0) }
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
        case .setBanks(let banks):
            newState.banks = banks
        }
        
        return newState
    }
}
