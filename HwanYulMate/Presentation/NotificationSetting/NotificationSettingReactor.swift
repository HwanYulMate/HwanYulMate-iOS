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
        case didLoadView
        case tapBackBarButtonItem
        case tapAlarmSwitch
        case tapScheduleSwitch
    }
    
    enum Mutation {
        case setRoute(Route)
        case setAlertSetting(AlertSetting)
        case setIsAlarmSwitchOn(Bool)
        case setIsScheduleSwitchOn(Bool)
    }
    
    struct State {
        var route: Route?
        var currencyCode: String = ""
        var alertSetting: AlertSetting?
        var isAlarmSwitchOn: Bool = false
        var isScheduleSwitchOn: Bool = false
    }
    
    enum Route {
        case pop
        case targetRate
        case timeSelection
    }
    
    // MARK: - properties
    let initialState: State
    
    private let repository: AlertSettingsRepository
    
    // MARK: - life cycles
    init(currencyCode: String) {
        self.initialState = State(currencyCode: currencyCode)
        repository = AlertSettingsRepositoryImpl()
    }
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didLoadView:
            return repository.fetchAlertSetting(currencyCode: currentState.currencyCode)
                .asObservable()
                .map { Mutation.setAlertSetting($0) }
        case .tapBackBarButtonItem:
            return .just(.setRoute(.pop))
        case .tapAlarmSwitch:
            return .just(.setRoute(.targetRate))
        case .tapScheduleSwitch:
            return .just(.setRoute(.timeSelection))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setAlertSetting(let alertSetting):
            newState.alertSetting = alertSetting
        case .setRoute(let route):
            newState.route = route
        case .setIsAlarmSwitchOn(let isOn):
            newState.isAlarmSwitchOn = isOn
        case .setIsScheduleSwitchOn(let isOn):
            newState.isScheduleSwitchOn = isOn
        }
        
        return newState
    }
}
