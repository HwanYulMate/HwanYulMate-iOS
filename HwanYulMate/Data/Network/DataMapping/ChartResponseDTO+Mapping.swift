//
//  ChartResponseDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/14/25.
//

import Foundation

struct ChartResponseDTO: Decodable {
    let date: String
    let rate: Double
    let timestamp: String
}

// MARK: - extensions
extension ChartResponseDTO {
    func toEntity() -> Chart {
        return .init(
            date: date,
            rate: rate,
            timestamp: timestamp
        )
    }
}
