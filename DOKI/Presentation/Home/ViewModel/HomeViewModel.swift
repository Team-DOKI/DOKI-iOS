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
    private let profileAPIService: ProfileAPIServiceProtocol

    init(
        homeAPIService: HomeAPIServiceProtocol = HomeAPIService(),
        profileAPIService: ProfileAPIServiceProtocol = ProfileAPIService()
    ) {
        self.homeAPIService = homeAPIService
        self.profileAPIService = profileAPIService

        fetchWeather()
        fetchTotalWalkStat()
        fetchPetName()
    }

    // MARK: - Published Properties

    @Published var weather: WeatherResponse?
    @Published var walkInfo: TotalWalkStatResponse?
    @Published var petName: String = ""
    
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
    
    var totalDistance: Double {
        walkInfo?.distance ?? 0
    }
    
    var totalWalkCount: Int {
        walkInfo?.count ?? 0
    }
    
    var totalWalkTimeText: String {
        formatSecondsToTime(walkInfo?.totalTime ?? 0)
    }
    
    // MARK: - Navigation
    
    var navigationAction: ((HomeAction)->())?
    
    func navigateToWalkRecord() {
        navigationAction?(.walkRecord)
    }
    
    // MARK: - Helper
    
    private func formatSecondsToTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - API

extension HomeViewModel {
    /// 날씨 조회
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
    
    /// 반려견 이름 조회
    func fetchPetName() {
        let petId = AuthManager.shared.petId
        guard petId > 0 else { return }

        profileAPIService.fetchPetProfile(petId: petId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.petName = response?.data?.name ?? ""
                default:
                    print("반려견 이름 조회에 실패했습니다.")
                }
            }
        }
    }

    /// 누적 산책 정보 조회
    func fetchTotalWalkStat() {
        homeAPIService.fetchTotalWalkStat { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.walkInfo = response?.data
                    
                default:
                    print("산책 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
}
