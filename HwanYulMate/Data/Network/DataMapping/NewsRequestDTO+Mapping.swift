//
//  NewsRequestDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/15/25.
//

import Foundation

struct NewsRequestDTO: Encodable {
    let currencyCode: String
    let page: Int
    let size: Int
}
