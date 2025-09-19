//
//  NewsRepository.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/15/25.
//

import Foundation
import RxSwift

protocol NewsRepository {
    func fetchNews(currencyCode: String) -> Single<News>
}
