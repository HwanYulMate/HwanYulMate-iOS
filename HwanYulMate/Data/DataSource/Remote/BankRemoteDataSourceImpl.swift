//
//  BankRemoteDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation
import RxSwift

protocol BankRemoteDataSource {
    func fetchAllBankExchangeInfos(currencyCode: String, exchangeRate: Double) -> Single<[BankResponseDTO]>
}

final class BankRemoteDataSourceImpl: BankRemoteDataSource {
    
    // MARK: - properties
    private let networkService: NetworkService
    
    // MARK: - life cycles
    init() {
        networkService = NetworkService()
    }
    
    // MARK: - methods
    func fetchAllBankExchangeInfos(currencyCode: String, exchangeRate: Double) -> Single<[BankResponseDTO]> {
        let request = BankRequestDTO(currencyCode: currencyCode, amount: exchangeRate, direction: "KRW_TO_FOREIGN")
        let endpoint = BankEndpoint.fetchAllBankExchangeInfos(request: request)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [BankResponseDTO]
        }
    }
}
