//
//  BankRepositoryImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation
import RxSwift

final class BankRepositoryImpl: BankRepository {
    
    // MARK: - properties
    private let remote: BankRemoteDataSource
    
    // MARK: - life cycles
    init() {
        remote = BankRemoteDataSourceImpl()
    }
    
    // MARK: - methods
    func fetchAllBankExchangeInfos(currencyCode: String, exchangeRate: Double) -> Single<[Bank]> {
        return remote.fetchAllBankExchangeInfos(
            currencyCode: currencyCode,
            exchangeRate: exchangeRate
        ).map { $0.map { $0.toEntity() } }
    }
}
