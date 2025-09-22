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
        case tapAlarmSwitch(Bool)
        case tapScheduleSwitch(Bool)
        case applyTargetRate(TargetPrice?)
        case applyDailyAlert(DailyAlert?)
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setAlertSetting(AlertSetting?)
        case setIsAlarmSwitchOn(Bool)
        case setIsScheduleSwitchOn(Bool)
        case setTargetRate(TargetPrice?)
        case setDailyAlert(DailyAlert?)
    }
    
    struct State {
        var route: Route?
        var currencyCode: String = ""
        var alertSetting: AlertSetting?
        var isAlarmSwitchOn: Bool = false
        var isScheduleSwitchOn: Bool = false
        var navigationTitle: String = ""
    }
    
    enum Route {
        case pop
        case targetRate(String)
        case timeSelection(String)
    }
    
    // MARK: - properties
    let initialState: State
    
    private let repository: AlertSettingsRepository
    
    // MARK: - life cycles
    init(currencyCode: String, navigationTitle: String) {
        self.initialState = State(currencyCode: currencyCode, navigationTitle: navigationTitle)
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
        case .tapAlarmSwitch(let isOn):
            if isOn {
                return .concat([
                    .just(.setIsAlarmSwitchOn(isOn)),
                    .just(.setRoute(.targetRate(currentState.currencyCode))),
                    .just(.setRoute(nil))
                ])
            } else {
                return repository.disableTargetPriceAlert(currencyCode: currentState.currencyCode)
                    .asObservable()
                    .map { Mutation.setTargetRate($0) }
            }
        case .tapScheduleSwitch(let isOn):
            if isOn {
                return .concat([
                    .just(.setIsScheduleSwitchOn(isOn)),
                    .just(.setRoute(.timeSelection(currentState.currencyCode))),
                    .just(.setRoute(nil))
                ])
            } else {
                return repository.disableDailyAlert(currencyCode: currentState.currencyCode)
                    .asObservable()
                    .map { Mutation.setDailyAlert($0) }
            }
        case .applyTargetRate(let targetPrice):
            if let targetPrice {
                return .just(.setTargetRate(targetPrice))
            } else {
                return .just(.setIsAlarmSwitchOn(false))
            }
        case .applyDailyAlert(let dailyAlert):
            if let dailyAlert {
                return .just(.setDailyAlert(dailyAlert))
            } else {
                return .just(.setIsScheduleSwitchOn(false))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setAlertSetting(let alertSetting):
            newState.alertSetting = alertSetting
            newState.isAlarmSwitchOn = alertSetting?.isTargetPriceEnabled ?? false
            newState.isScheduleSwitchOn = alertSetting?.isDailyAlertEnabled ?? false
        case .setRoute(let route):
            newState.route = route
        case .setIsAlarmSwitchOn(let isOn):
            newState.isAlarmSwitchOn = isOn
        case .setIsScheduleSwitchOn(let isOn):
            newState.isScheduleSwitchOn = isOn
        case .setTargetRate(let targetPrice):
            if let targetPrice {
                if targetPrice.success && targetPrice.status == "ENABLED" {
                    newState.isAlarmSwitchOn = true
                } else if targetPrice.success && targetPrice.status == "DISABLED" {
                    newState.isAlarmSwitchOn = false
                }
            } else {
                newState.isAlarmSwitchOn = false
            }
        case .setDailyAlert(let dailyAlert):
            if let dailyAlert {
                if dailyAlert.success && dailyAlert.status == "ENABLED" {
                    newState.isScheduleSwitchOn = true
                } else if dailyAlert.success && dailyAlert.status == "DISABLED" {
                    newState.isScheduleSwitchOn = false
                }
            } else {
                newState.isScheduleSwitchOn = false
            }
        }
        
        return newState
    }
}
