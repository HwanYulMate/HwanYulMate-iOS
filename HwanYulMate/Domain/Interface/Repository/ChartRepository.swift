//
//  ChartRepository.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/14/25.
//

import Foundation
import RxSwift

protocol ChartRepository {
    func fetchWeeklyChart(currencyCode: String) -> Single<[Chart]>
    func fetchMonthlyChart(currencyCode: String) -> Single<[Chart]>
    func fetchThreeMonthsChart(currencyCode: String) -> Single<[Chart]>
    func fetchSixMonthsChart(currencyCode: String) -> Single<[Chart]>
    func fetchYearlyChart(currencyCode: String) -> Single<[Chart]>
}
