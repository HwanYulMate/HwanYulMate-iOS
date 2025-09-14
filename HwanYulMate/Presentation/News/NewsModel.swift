//
//  NewsModel.swift
//  HwanYulMate
//
//  Created by HanJW on 9/1/25.
//

import Foundation

struct NewsModel: Codable {
    let id: String
    let title: String
    let publishedDate: String
    let url: String
    let link: String?
    let description: String?
    let pubDate: String?
}

// MARK: - 네트워킹 응답 모델 (수정됨)
struct NewsSearchResponse: Codable {
    let newsList: [NewsItem]
    let currentPage: Int
    let pageSize: Int
    let totalCount: Int
    let hasNext: Bool
}

struct NewsItem: Codable {
    let title: String
    let description: String
    let link: String
    let originalLink: String
    let pubDate: String
    
    func toNewsModel() -> NewsModel {
        let cleanTitle = removeHTMLTags(from: title)
        let cleanDescription = removeHTMLTags(from: description)
        let formattedDate = formatDateString(pubDate)
        
        return NewsModel(
            id: UUID().uuidString,
            title: cleanTitle,
            publishedDate: formattedDate,
            url: originalLink,  // originalLink 사용
            link: link,
            description: cleanDescription,
            pubDate: pubDate
        )
    }
    
    private func removeHTMLTags(from string: String) -> String {
        return string.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US")
        
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
        case 7..<14:
            return "1주 전"
        default:
            return "\(days / 7)주 전"
        }
    }
}

// MARK: - Mock Data
extension NewsModel {
    static let mockData: [NewsModel] = [
        NewsModel(
            id: "1",
            title: "달러-원, 달러 선물 매도세에 한 때1,380원 하회(상보)",
            publishedDate: "2일 전",
            url: "https://www.example.com/news/1",
            link: "https://www.example.com/news/1",
            description: "달러-원 환율이 하락세를 보이고 있습니다.",
            pubDate: "2024-01-10"
        ),
        NewsModel(
            id: "2",
            title: "안갯속 관세 협상과 연준의 선택, 환율은 어디로 향할까?",
            publishedDate: "2일 전",
            url: "https://www.example.com/news/2",
            link: "https://www.example.com/news/2",
            description: "관세 협상과 연준 정책이 환율에 미치는 영향을 분석합니다.",
            pubDate: "2024-01-10"
        ),
        NewsModel(
            id: "3",
            title: "킹달러의 귀환? 다시 1,400원을 위협하는 환율",
            publishedDate: "2일 전",
            url: "https://www.example.com/news/3",
            link: "https://www.example.com/news/3",
            description: "달러 강세가 지속되고 있습니다.",
            pubDate: "2024-01-10"
        ),
        NewsModel(
            id: "4",
            title: "'관세 데드라인' 맞은 환율, 어디로 튈까?",
            publishedDate: "2일 전",
            url: "https://www.example.com/news/4",
            link: "https://www.example.com/news/4",
            description: "관세 정책과 환율 전망을 살펴봅니다.",
            pubDate: "2024-01-10"
        )
    ]
}
