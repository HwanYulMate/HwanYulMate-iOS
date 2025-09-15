//
//  ChartRepositoryImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/14/25.
//

import Foundation
import RxSwift

final class ChartRepositoryImpl: ChartRepository {
    
    // MARK: - properties
    private let remote: ChartRemoteDataSource
    
    // MARK: - life cycles
    init() {
        remote = ChartRemoteDataSourceImpl()
    }
    
    // MARK: - methods
    func fetchWeeklyChart(currencyCode: String) -> Single<[Chart]> {
        return remote.fetchWeeklyChart(currencyCode: currencyCode).map { $0.map { $0.toEntity() } }
    }
    
    func fetchMonthlyChart(currencyCode: String) -> Single<[Chart]> {
        return remote.fetchMonthlyChart(currencyCode: currencyCode).map { $0.map { $0.toEntity() } }
    }
    
    func fetchThreeMonthsChart(currencyCode: String) -> Single<[Chart]> {
        return remote.fetchThreeMonthsChart(currencyCode: currencyCode).map { $0.map { $0.toEntity() } }
    }
    
    func fetchSixMonthsChart(currencyCode: String) -> Single<[Chart]> {
        return remote.fetchSixMonthsChart(currencyCode: currencyCode).map { $0.map { $0.toEntity() } }
    }
    
    func fetchYearlyChart(currencyCode: String) -> Single<[Chart]> {
        return remote.fetchYearlyChart(currencyCode: currencyCode).map { $0.map { $0.toEntity() } }
    }
}
