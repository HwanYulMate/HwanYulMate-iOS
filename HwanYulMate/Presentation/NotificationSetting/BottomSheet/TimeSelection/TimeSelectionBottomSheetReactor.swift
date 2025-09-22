//
//  TimeSelectionBottomSheetReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/8/25.
//

import Foundation
import ReactorKit

final class TimeSelectionBottomSheetReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case didAppearView
        case tapSelectButton(Int, String)
        case tapLeadingButton
        case tapTrailingButton(String)
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setSelectedButton(String)
        case setSelectedButtonIndex(Int)
        case setContainerHeightConstraint(Float)
        case updateContainerBottomConstraint(Float)
        case setDailyAlert(DailyAlert)
    }
    
    struct State {
        var route: Route?
        var selectedButton: String = "09:00"
        var selectedButtonIndex: Int = 0
        var containerBottomConstraint: Float = 385
        var containerHeightConstraint: Float = 385
        var currencyCode: String = ""
        var dailyAlert: DailyAlert?
    }
    
    enum Route {
        case dismiss
        case alert
    }
    
    // MARK: - properties
    let initialState: State
    
    private let alertSettingsRepository: AlertSettingsRepository
    
    // MARK: - life cycles
    init(currencyCode: String) {
        self.initialState = State(currencyCode: currencyCode)
        self.alertSettingsRepository = AlertSettingsRepositoryImpl()
    }
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didAppearView:
            return .merge(
                .just(.setContainerHeightConstraint(385)),
                .just(.updateContainerBottomConstraint(0.0))
            )
        case .tapSelectButton(let index, let timeSelection):
            return .merge(
                .just(.setSelectedButton(timeSelection)),
                .just(.setSelectedButtonIndex(index))
            )
        case .tapLeadingButton:
            return .just(.updateContainerBottomConstraint(385))
        case .tapTrailingButton(let dailyAlert):
            let dailyAlert = alertSettingsRepository
                .enableDailyAlert(
                    currencyCode: currentState.currencyCode,
                    alertTime: dailyAlert
                )
                .asObservable()
                .map { Mutation.setDailyAlert($0) }
            
            return .concat([
                dailyAlert,
                .just(.setRoute(.alert)),
                .just(.setRoute(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRoute(let route):
            newState.route = route
        case .setSelectedButton(let timeSelection):
            newState.selectedButton = timeSelection
        case .setSelectedButtonIndex(let index):
            newState.selectedButtonIndex = index
        case .setContainerHeightConstraint(let constraint):
            newState.containerHeightConstraint = constraint
        case .updateContainerBottomConstraint(let constraint):
            newState.containerBottomConstraint = constraint
        case .setDailyAlert(let dailyAlert):
            newState.dailyAlert = dailyAlert
        }
        
        return newState
    }
}
