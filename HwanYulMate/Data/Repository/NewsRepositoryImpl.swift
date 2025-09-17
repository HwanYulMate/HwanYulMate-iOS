//
//  NewsRepositoryImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/15/25.
//

import Foundation
import RxSwift

final class NewsRepositoryImpl: NewsRepository {
    
    // MARK: - properties
    private let remote: NewsRemoteDataSource
    
    // MARK: - life cycles
    init() {
        remote = NewsRemoteDataSourceImpl()
    }
    
    // MARK: - methods
    func fetchNews(currencyCode: String) -> Single<News> {
        return remote.fetchNews(currencyCode: currencyCode).map { $0.toEntity() }
    }
}
