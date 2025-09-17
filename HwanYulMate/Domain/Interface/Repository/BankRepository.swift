//
//  BankRepository.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation
import RxSwift

protocol BankRepository {
    func fetchAllBankExchangeInfos(currencyCode: String, exchangeRate: Double) -> Single<[Bank]>
}
