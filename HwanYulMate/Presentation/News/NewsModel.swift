//
//  NewsModel.swift
//  HwanYulMate
//
//  Created by HanJW on 9/1/25.
//

import Foundation

struct NewsModel {
    let id: String
    let title: String
    let publishedDate: String
    let url: String
}

// MARK: - Mock Data
extension NewsModel {
    static let mockData: [NewsModel] = [
        NewsModel(
            id: "1",
            title: "달러-원, 달러 선물 매도세에 한 때1,380원 하회(상보)",
            publishedDate: "2일 전",
            url: "https://www.example.com/news/1"
        ),
        NewsModel(
            id: "2",
            title: "안갯속 관세 협상과 연준의 선택, 환율은 어디로 향할까? 로 향할까?로 향할까?로 향할까?로 향할까?",
            publishedDate: "2일 전",
            url: "https://www.example.com/news/2"
        ),
        NewsModel(
            id: "3",
            title: "킹달러의 귀환? 다시 1,400원을 위협하는 환율",
            publishedDate: "2일 전",
            url: "https://www.example.com/news/3"
        ),
        NewsModel(
            id: "4",
            title: "‘관세 데드라인’ 맞은 환율, 어디로 튈까?",
            publishedDate: "2일 전",
            url: "https://www.example.com/news/4"
        ),
        NewsModel(
            id: "5",
            title: "미국 고용지표가 향방 가를 이번주 외환시장",
            publishedDate: "6일 전",
            url: "https://www.example.com/news/5"
        ),
        NewsModel(
            id: "6",
            title: "미국 고용지표가 향방 가를 이번주 외환시장미국 고용지표가 향방 가를 이번주 외환시장",
            publishedDate: "1주 전",
            url: "https://www.example.com/news/6"
        ),
        NewsModel(
            id: "7",
            title: "미국 고용지표가 향방 가를 이번주 외환시장미국 고용지표가 향방 가를 이번주 외환시장",
            publishedDate: "1주 전",
            url: "https://www.example.com/news/7"
        ),
        NewsModel(
            id: "8",
            title: "미국 고용지표가 향방 가를 이번주 외환시장미국 고용지표가 향방 가를 이번주 외환시장",
            publishedDate: "2주 전",
            url: "https://www.example.com/news/8"
        )
    ]
}
