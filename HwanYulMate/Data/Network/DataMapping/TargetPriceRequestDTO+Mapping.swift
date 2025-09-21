//
//  TargetPriceRequestDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation

struct TargetPriceRequestDTO: Encodable {
    let targetPrice: Double
    let condition: String
}
