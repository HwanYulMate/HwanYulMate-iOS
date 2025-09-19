//
//  AlertSettingsRemoteDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation
import RxSwift

protocol AlertSettingsRemoteDataSource {
    func fetchAlertSetting(token: String, currencyCode: String) -> Single<AlertSettingResponseDTO>
    func fetchAllAlertSettings(token: String) -> Single<[AlertSettingResponseDTO]>
}

final class AlertSettingsRemoteDataSourceImpl: AlertSettingsRemoteDataSource {
    
    // MARK: - properties
    private let networkService: NetworkService
    
    // MARK: - life cycles
    init() {
        networkService = NetworkService()
    }
    
    // MARK: - methods
    func fetchAlertSetting(token: String, currencyCode: String) -> Single<AlertSettingResponseDTO> {
        let request = AlertSettingRequestDTO(currencyCode: currencyCode)
        let endpoint = AlertSettingEndpoint.fetchAlertSetting(request: request, token: token)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as AlertSettingResponseDTO
        }
    }
    
    func fetchAllAlertSettings(token: String) -> Single<[AlertSettingResponseDTO]> {
        let endpoint = AlertSettingEndpoint.fetchAllAlertSettings(token: token)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [AlertSettingResponseDTO]
        }
    }
}
