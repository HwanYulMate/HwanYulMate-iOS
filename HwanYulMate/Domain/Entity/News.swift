//
//  News.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/15/25.
//

import Foundation

struct News {
    let newsList: [NewsItem]
    let currentPage: Int
    let pageSize: Int
    let totalCount: Int
    let hasNext: Bool
}

//struct NewsItem {
//    let title: String
//    let description: String
//    let link: String
//    let originalLink: String
//    let pubDate: String
//}
