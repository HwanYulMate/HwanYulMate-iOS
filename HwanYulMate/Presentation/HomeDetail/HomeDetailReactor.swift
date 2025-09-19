//
//  HomeDetailReactor.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import Foundation
import ReactorKit

final class HomeDetailReactor: Reactor {
    
    // MARK: - nested types
    enum Action {
        case didLoadView
        case tapBackBarButtonItem
        case tapSegmentedControl(Int)
        case tapNewsButton(Int)
        case tapExchangeEstimateComparisonButton
    }
    
    enum Mutation {
        case setRoute(Route?)
        case setExchangeRate(ExchangeRate)
        case setChart([Chart])
        case setExchangeRateChangeTitle(String)
        case setNews(News)
    }
    
    struct State {
        var route: Route?
        var navigationTitle: String = ""
        var currencyCode: String = ""
        var exchangeRate: ExchangeRate?
        var chart: [Chart] = []
        var exchangeRateChangeTitle: String = "최근 1주일 환율 변동"
        var news: News?
    }
    
    enum Route {
        case pop
        case news(String)
        case bottomSheet(String, Double)
    }
    
    // MARK: - properties
    let initialState: State
    
    private let exchangeRateRepository: ExchangeRateRepository
    private let chartRepository: ChartRepository
    private let newsRepository: NewsRepository
    
    // MARK: - life cycles
    init(currencyCode: String) {
        self.initialState = State(currencyCode: currencyCode)
        self.exchangeRateRepository = ExchangeRateRepositoryImpl()
        self.chartRepository = ChartRepositoryImpl()
        self.newsRepository = NewsRepositoryImpl()
    }
    
    // MARK: - methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didLoadView:
            let exchangeRate = exchangeRateRepository.fetchExchangeRate(currencyCode: currentState.currencyCode)
                .asObservable()
                .map { Mutation.setExchangeRate($0) }
            let weeklyChart = chartRepository.fetchWeeklyChart(currencyCode: currentState.currencyCode)
                .asObservable()
                .map { Mutation.setChart($0) }
            let news = newsRepository.fetchNews(currencyCode: currentState.currencyCode)
                .asObservable()
                .map { Mutation.setNews($0) }
            
            return .merge(exchangeRate, weeklyChart, news)
        case .tapBackBarButtonItem:
            return .just(.setRoute(.pop))
        case .tapSegmentedControl(let index):
            switch index {
            case 0:
                let weeklyChart = chartRepository.fetchWeeklyChart(currencyCode: currentState.currencyCode)
                    .asObservable()
                    .map { Mutation.setChart($0) }
                let exchangeRateChangeTitle = Observable.just("최근 1주일 환율 변동")
                    .map { Mutation.setExchangeRateChangeTitle($0) }
                
                return .merge(weeklyChart, exchangeRateChangeTitle)
            case 1:
                let monthlyChart = chartRepository.fetchMonthlyChart(currencyCode: currentState.currencyCode)
                    .asObservable()
                    .map { Mutation.setChart($0) }
                let exchangeRateChangeTitle = Observable.just("최근 1개월 환율 변동")
                    .map { Mutation.setExchangeRateChangeTitle($0) }
                
                return .merge(monthlyChart, exchangeRateChangeTitle)
            case 2:
                let threeMonthsChart = chartRepository.fetchThreeMonthsChart(currencyCode: currentState.currencyCode)
                    .asObservable()
                    .map { Mutation.setChart($0) }
                let exchangeRateChangeTitle = Observable.just("최근 3개월 환율 변동")
                    .map { Mutation.setExchangeRateChangeTitle($0) }
                
                return .merge(threeMonthsChart, exchangeRateChangeTitle)
            case 3:
                let sixMonthsChart = chartRepository.fetchSixMonthsChart(currencyCode: currentState.currencyCode)
                    .asObservable()
                    .map { Mutation.setChart($0) }
                let exchangeRateChangeTitle = Observable.just("최근 6개월 환율 변동")
                    .map { Mutation.setExchangeRateChangeTitle($0) }
                
                return .merge(sixMonthsChart, exchangeRateChangeTitle)
            default:
                let yearlyChart = chartRepository.fetchYearlyChart(currencyCode: currentState.currencyCode)
                    .asObservable()
                    .map { Mutation.setChart($0) }
                let exchangeRateChangeTitle = Observable.just("최근 1년 환율 변동")
                    .map { Mutation.setExchangeRateChangeTitle($0) }
                
                return .merge(yearlyChart, exchangeRateChangeTitle)
            }
        case .tapNewsButton(let index):
            if let news = currentState.news {
                return .just(.setRoute(.news(news.newsList[index].originalLink)))
            } else {
                return .just(.setRoute(nil))
            }
        case .tapExchangeEstimateComparisonButton:
            if let exchangeRate = currentState.exchangeRate?.exchangeRate {
                return .just(.setRoute(.bottomSheet(currentState.currencyCode, exchangeRate)))
            } else {
                return .just(.setRoute(nil))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRoute(let route):
            newState.route = route
        case .setExchangeRate(let exchangeRate):
            let currencyNameArray = exchangeRate.currencyName.components(separatedBy: " ")
            newState.navigationTitle = currencyNameArray[0] + " \(exchangeRate.currencyCode) (\(currencyNameArray[1]))"
            newState.exchangeRate = exchangeRate
        case .setChart(let chart):
            newState.chart = chart
        case .setExchangeRateChangeTitle(let exchangeRateChangeTitle):
            newState.exchangeRateChangeTitle = exchangeRateChangeTitle
        case .setNews(let news):
            newState.news = news
        }
        
        return newState
    }
}
