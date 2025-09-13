//
//  ExchangeRateRepository.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation
import RxSwift

protocol ExchangeRateRepository {
    func fetchAllExchangeRates() -> Single<[ExchangeRate]>
}
