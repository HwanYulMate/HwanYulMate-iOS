//
//  NewsResponseDTO+Mapping.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/15/25.
//

import Foundation

struct NewsResponseDTO: Decodable {
    let newsList: [NewsItemResponseDTO]
    let currentPage: Int
    let pageSize: Int
    let totalCount: Int
    let hasNext: Bool
}

// MARK: - extensions
extension NewsResponseDTO {
    struct NewsItemResponseDTO: Decodable {
        let title: String
        let description: String
        let link: String
        let originalLink: String
        let pubDate: String
    }
}

extension NewsResponseDTO {
    func toEntity() -> News {
        return .init(
            newsList: newsList.map { $0.toEntity() },
            currentPage: currentPage,
            pageSize: pageSize,
            totalCount: totalCount,
            hasNext: hasNext
        )
    }
}

extension NewsResponseDTO.NewsItemResponseDTO {
    func toEntity() -> NewsItem {
        return .init(
            title: title,
            description: description,
            link: link,
            originalLink: originalLink,
            pubDate: formatDateString(pubDate)
        )
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        return formatRelativeDate(from: date)
    }
    
    private func formatRelativeDate(from date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        let days = Int(timeInterval / (24 * 60 * 60))
        
        switch days {
        case 0:
            return "오늘"
        case 1:
            return "1일 전"
        case 2..<7:
            return "\(days)일 전"
        default:
            return "\(days / 7)주 전"
        }
    }
}
