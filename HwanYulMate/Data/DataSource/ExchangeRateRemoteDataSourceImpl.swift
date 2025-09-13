//
//  ExchangeRateRemoteDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation
import RxSwift

protocol ExchangeRateRemoteDataSource {
    func fetchAllExchangeRates() -> Single<[ExchangeRateResponseDTO]>
}

final class ExchangeRateRemoteDataSourceImpl: ExchangeRateRemoteDataSource {
    
    // MARK: - properties
    private let networkService: NetworkService
    
    // MARK: - life cycles
    init() {
        networkService = NetworkService()
    }
    
    // MARK: - methods
    func fetchAllExchangeRates() -> Single<[ExchangeRateResponseDTO]> {
        let endpoint = ExchangeRateEndpoint.fetchAllExchangeRates
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [ExchangeRateResponseDTO]
        }
    }
}
