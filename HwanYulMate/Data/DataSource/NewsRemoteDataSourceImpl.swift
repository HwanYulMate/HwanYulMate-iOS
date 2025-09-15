//
//  NewsRemoteDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/15/25.
//

import Foundation
import RxSwift

protocol NewsRemoteDataSource {
    func fetchNews(currencyCode: String) -> Single<NewsResponseDTO>
}

final class NewsRemoteDataSourceImpl: NewsRemoteDataSource {
    
    // MARK: - properties
    private let networkService: NetworkService
    
    // MARK: - life cycles
    init() {
        networkService = NetworkService()
    }
    
    // MARK: - methods
    func fetchNews(currencyCode: String) -> Single<NewsResponseDTO> {
        let request = NewsRequestDTO(currencyCode: currencyCode, page: 0, size: 5)
        let endpoint = NewsEndpoint.fetchNews(request: request)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as NewsResponseDTO
        }
    }
}
