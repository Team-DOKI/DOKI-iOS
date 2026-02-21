//
//  HomeViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI
import Moya

class HomeViewModel: ObservableObject {
    private let homeAPIService: HomeAPIServiceProtocol
    
    init(
        homeAPIService: HomeAPIServiceProtocol = HomeAPIService()
    ) {
        self.homeAPIService = homeAPIService
        fetchWeather()
    }
    
    // MARK: - Published Properties
    
    @Published var weather: WeatherResponse?
    
    // MARK: - Computed Properties (UI)
    
    var temperatureText: String {
        "\(weather?.temperature ?? 0)°C"
    }
    
    var rainyText: String {
        "\(weather?.rainyMm ?? 0)mm"
    }
    
    var regionText: String {
        weather?.region ?? "지역 정보 없음"
    }
    
    // MARK: - Navigation
    
    var navigationAction: ((HomeAction)->())?
    
    func navigateToWalkRecord() {
        navigationAction?(.walkRecord)
    }
}

// MARK: - API

extension HomeViewModel {
    /// 날씨 정보 조회
    func fetchWeather() {
        homeAPIService.fetchWeather { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.weather = response?.data
                    
                default:
                    print("날씨 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
}
