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
        case didLoadView
        case tapBackBarButtonItem
        case tapCellItem(IndexPath)
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setAlertSettings([AlertSetting])
        case setCurrencyCode(String)
    }
    
    struct State {
        var route: Route?
        var exchangeRates: [ExchangeRate] = []
        var alertSettings: [AlertSetting] = []
        var currencyCode: String = ""
    }
    
    enum Route {
        case pop
        case notificationSetting(String)
    }
    
    // MARK: - properties
    let initialState: State
    
    private let repository: AlertSettingsRepository
    
    // MARK: - life cycles
    init(exchangeRates: [ExchangeRate]) {
        initialState = State(exchangeRates: exchangeRates)
        repository = AlertSettingsRepositoryImpl()
    }
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didLoadView:
            return repository.fetchAllAlertSettings()
                .asObservable()
                .map { Mutation.setAlertSettings($0) }
        case .tapBackBarButtonItem:
            return .just(.setRoute(.pop))
        case .tapCellItem(let index):
            return .just(.setCurrencyCode(currentState.alertSettings[index.row].currencyCode))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRoute(let route):
            newState.route = route
        case .setAlertSettings(let alertSettings):
            newState.alertSettings = alertSettings
        case .setCurrencyCode(let currencyCode):
            newState.currencyCode = currencyCode
            newState.route = .notificationSetting(currencyCode)
        }
        
        return newState
    }
}
