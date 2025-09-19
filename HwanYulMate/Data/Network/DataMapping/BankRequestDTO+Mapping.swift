//
//  BankRequestDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/16/25.
//

import Foundation

struct BankRequestDTO: Encodable {
    let currencyCode: String
    let amount: Double
    let direction: String
}
