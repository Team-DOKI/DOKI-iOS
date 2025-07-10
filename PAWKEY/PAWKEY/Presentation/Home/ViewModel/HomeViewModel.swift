//
//  HomeViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/10/25.
//

import SwiftUI

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
}
