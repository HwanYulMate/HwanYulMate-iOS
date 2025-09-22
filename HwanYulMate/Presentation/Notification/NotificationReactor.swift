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
        case willAppearView
        case tapBackBarButtonItem
        case tapCellItem(IndexPath, String)
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setAlertSettings([AlertSetting])
        case setCurrencyCode(String)
        case setNotificationSettingTitle(String)
    }
    
    struct State {
        var route: Route?
        var exchangeRates: [ExchangeRate] = []
        var alertSettings: [AlertSetting] = []
        var currencyCode: String = ""
        var notificationSettingTitle: String = ""
    }
    
    enum Route {
        case pop
        case notificationSetting(String, String)
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
        case .willAppearView:
            return repository.fetchAllAlertSettings()
                .asObservable()
                .map { Mutation.setAlertSettings($0) }
        case .tapBackBarButtonItem:
            return .just(.setRoute(.pop))
        case .tapCellItem(let index, let notificationSettingTitle):
            return .merge([
                .just(.setNotificationSettingTitle(notificationSettingTitle)),
                .just(.setCurrencyCode(currentState.alertSettings[index.row].currencyCode)),
                .just(.setRoute(nil))
            ])
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
            newState.route = .notificationSetting(currencyCode, currentState.notificationSettingTitle)
        case .setNotificationSettingTitle(let title):
            newState.notificationSettingTitle = title
        }
        
        return newState
    }
}
