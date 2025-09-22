//
//  AlertSettingsRemoteDataSourceImpl.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/17/25.
//

import Foundation
import RxSwift

protocol AlertSettingsRemoteDataSource {
    func fetchAlertSetting(token: String, currencyCode: String) -> Single<[AlertSettingResponseDTO]>
    func fetchAllAlertSettings(token: String) -> Single<[AlertSettingResponseDTO]>
    func enableTargetPriceAlert(
        token: String,
        currencyCode: String,
        targetPrice: Double,
        condition: String
    ) -> Single<TargetPriceResponseDTO>
    func disableTargetPriceAlert(
        token: String,
        currencyCode: String
    ) -> Single<TargetPriceResponseDTO>
    func enableDailyAlert(
        token: String,
        currencyCode: String,
        alertTime: String
    ) -> Single<DailyAlertResponseDTO>
    func disableDailyAlert(
        token: String,
        currencyCode: String
    ) -> Single<DailyAlertResponseDTO>
}

final class AlertSettingsRemoteDataSourceImpl: AlertSettingsRemoteDataSource {
    
    // MARK: - properties
    private let networkService: NetworkService
    
    // MARK: - life cycles
    init() {
        networkService = NetworkService()
    }
    
    // MARK: - methods
    func fetchAlertSetting(token: String, currencyCode: String) -> Single<[AlertSettingResponseDTO]> {
        let request = AlertSettingRequestDTO(currencyCode: currencyCode)
        let endpoint = AlertSettingEndpoint.fetchAlertSetting(request: request, token: token)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [AlertSettingResponseDTO]
        }
    }
    
    func fetchAllAlertSettings(token: String) -> Single<[AlertSettingResponseDTO]> {
        let endpoint = AlertSettingEndpoint.fetchAllAlertSettings(token: token)
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as [AlertSettingResponseDTO]
        }
    }
    
    func enableTargetPriceAlert(
        token: String,
        currencyCode: String,
        targetPrice: Double,
        condition: String
    ) -> Single<TargetPriceResponseDTO> {
        let request = TargetPriceRequestDTO(targetPrice: targetPrice, condition: condition)
        let endpoint = TargetPriceEndpoint.enableTargetPriceAlert(
            token: token,
            currencyCode: currencyCode,
            request: request
        )
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as TargetPriceResponseDTO
        }
    }
    
    func disableTargetPriceAlert(
        token: String,
        currencyCode: String
    ) -> Single<TargetPriceResponseDTO> {
        let endpoint = TargetPriceEndpoint.disableTargetPriceAlert(
            token: token,
            currencyCode: currencyCode
        )
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as TargetPriceResponseDTO
        }
    }
    
    func enableDailyAlert(
        token: String,
        currencyCode: String,
        alertTime: String
    ) -> Single<DailyAlertResponseDTO> {
        let request = DailyAlertRequestDTO(alertTime: alertTime)
        let endpoint = DailyAlertEndpoint.enableDailyAlert(
            token: token,
            currencyCode: currencyCode,
            request: request
        )
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as DailyAlertResponseDTO
        }
    }
    
    func disableDailyAlert(
        token: String,
        currencyCode: String
    ) -> Single<DailyAlertResponseDTO> {
        let endpoint = DailyAlertEndpoint.disableDailyAlert(
            token: token,
            currencyCode: currencyCode
        )
        
        return networkService.request(endpoint).map { data in
            try endpoint.responseDecoder.decode(data) as DailyAlertResponseDTO
        }
    }
}
