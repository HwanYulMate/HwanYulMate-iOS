//
//  NetworkService.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/13/25.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkService {
    
    // MARK: - methods
    func request<T: Endpoint>(_ endpoint: T) -> Single<Data> {
        return Single.create { single in
            do {
                let urlRequest = try endpoint.asURLRequest()
                let request = AF.request(urlRequest).validate(statusCode: 200..<300)
                
                request.responseData { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(data))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
                
                return Disposables.create { request.cancel() }
            } catch {
                return Disposables.create { single(.failure(error)) }
            }
        }
    }
}
