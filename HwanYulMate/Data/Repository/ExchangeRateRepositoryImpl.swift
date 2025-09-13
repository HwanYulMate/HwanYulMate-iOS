//
//  ExchangeRateRepositoryImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation
import RxSwift

final class ExchangeRateRepositoryImpl: ExchangeRateRepository {
    
    // MARK: - properties
    private let remote: ExchangeRateRemoteDataSource
    
    // MARK: - life cycles
    init() {
        remote = ExchangeRateRemoteDataSourceImpl()
    }
    
    // MARK: - methods
    func fetchAllExchangeRates() -> Single<[ExchangeRate]> {
        return remote.fetchAllExchangeRates().map { $0.map { $0.toEntity() } }
    }
}
