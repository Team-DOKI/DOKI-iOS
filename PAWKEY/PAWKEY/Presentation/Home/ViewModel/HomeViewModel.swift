//
//  HomeViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/10/25.
//

import SwiftUI
import Moya

struct Day: Hashable {
    let day: String
    let dayNumber: Int
}

final class HomeViewModel: ObservableObject {
    @Published var isShowMenu = false
    @Published var dayList = [
        Day(day: "월", dayNumber: 14),
        Day(day: "화", dayNumber: 15),
        Day(day: "수", dayNumber: 16),
        Day(day: "목", dayNumber: 17),
        Day(day: "금", dayNumber: 18),
        Day(day: "토", dayNumber: 19),
        Day(day: "일", dayNumber: 20),
    ]
    @Published var isShowContextMenu = false
    @Published var dummyData = ["이륜차 거의 없음", "배변 쓰레기통", "쉼터", "편의점", "동반 카페", "아스팔트/벽돌", "시끌벅적"]
    
    @Published var myRegion: String = ""
    
    @MainActor
    func fetchMyRegion() async {
        let provider = MoyaProvider<MyRegionAPI>()
        
        do {
            let response: BaseDTO<MyRegionDTO> = try await provider.async.request(.fetchMyRegion)
            
            guard let data = response.data else {
                return
            }
            
            self.myRegion = data.fullRegionName
            
            print(myRegion)
        } catch {
            print("Error fetching regions: \(error.localizedDescription)")
        }
    }
}
