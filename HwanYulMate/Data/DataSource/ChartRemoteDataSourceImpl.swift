//
//  ChartRemoteDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/14/25.
//

import Foundation
import RxSwift

protocol ChartRemoteDataSource {
    func fetchWeeklyChart(currencyCode: String) -> Single<[ChartResponseDTO]>
    func fetchMonthlyChart(currencyCode: String) -> Single<[ChartResponseDTO]>
    func fetchThreeMonthsChart(currencyCode: String) -> Single<[ChartResponseDTO]>
    func fetchSixMonthsChart(currencyCode: String) -> Single<[ChartResponseDTO]>
    func fetchYearlyChart(currencyCode: String) -> Single<[ChartResponseDTO]>
}

final class ChartRemoteDataSourceImpl: ChartRemoteDataSource {
    
    // MARK: - properties
    private let networkService: NetworkService
    
    // MARK: - life cycles
    init() {
        networkService = NetworkService()
    }
    
    // MARK: - methods
    func fetchWeeklyChart(currencyCode: String) -> Single<[ChartResponseDTO]> {
        let request = ChartRequestDTO(currencyCode: currencyCode)
        let endpoint = ChartEndpoint.fetchWeeklyChart(request: request)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [ChartResponseDTO]
        }
    }
    
    func fetchMonthlyChart(currencyCode: String) -> Single<[ChartResponseDTO]> {
        let request = ChartRequestDTO(currencyCode: currencyCode)
        let endpoint = ChartEndpoint.fetchMonthlyChart(request: request)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [ChartResponseDTO]
        }
    }
    
    func fetchThreeMonthsChart(currencyCode: String) -> Single<[ChartResponseDTO]> {
        let request = ChartRequestDTO(currencyCode: currencyCode)
        let endpoint = ChartEndpoint.fetchThreeMonthsChart(request: request)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [ChartResponseDTO]
        }
    }
    
    func fetchSixMonthsChart(currencyCode: String) -> Single<[ChartResponseDTO]> {
        let request = ChartRequestDTO(currencyCode: currencyCode)
        let endpoint = ChartEndpoint.fetchSixMonthsChart(request: request)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [ChartResponseDTO]
        }
    }
    
    func fetchYearlyChart(currencyCode: String) -> Single<[ChartResponseDTO]> {
        let request = ChartRequestDTO(currencyCode: currencyCode)
        let endpoint = ChartEndpoint.fetchYearlyChart(request: request)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [ChartResponseDTO]
        }
    }
}
