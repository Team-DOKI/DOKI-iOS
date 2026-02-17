//
//  HomeViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI
import Moya

class HomeViewModel: ObservableObject {
    @Published var weather: WeatherResponseDTO?
    
    private let provider = MoyaProvider<HomeAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    init() {
            fetchWeather()
        }
    
    var navigationAction: ((HomeAction)->())?
    
    func navigateToWalkRecord() {
        //        coordinator.presentFullScreen(.walkRecord)
        navigationAction?(.walkRecord)
    }
    
    func fetchWeather() {
        provider.request(.fetchWeather) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(BaseDTO<WeatherResponseDTO>.self, from: response.data)
                    DispatchQueue.main.async {
                        self.weather = decoded.data
                    }
                } catch {
                    print("날씨 디코딩 실패:", error)
                }
            case .failure(let error):
                print("날씨 API 호출 실패:", error.localizedDescription)
            }
        }
    }
}
