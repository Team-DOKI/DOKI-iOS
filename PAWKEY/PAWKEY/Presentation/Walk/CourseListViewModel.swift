//
//  CourseListViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/11/25.
//

import SwiftUI

final class CourseListViewModel: ObservableObject {
    
    enum WalkRouteOption {
        case walkingTime(index: Int)
        case safety(index: Int)
        case convenience(index: Int)
        case environment(index: Int)
        case mood(index: Int)
    }
    
    @Published var isExpandWalkingTime = false
    @Published var isExpandSafety = false
    @Published var isExpandConvenience = false
    @Published var isExpandEnvironment = false
    @Published var isExpandMood = false
    
    @Published var walkingTimeList: [CheckOption] = [
        .init(title: "20분 이내", isSelected: false),
        .init(title: "21~40분", isSelected: false),
        .init(title: "41~60분", isSelected: false),
        .init(title: "1시간 넘게", isSelected: false),
    ]
    
    @Published var safetyList: [CheckOption] = [
        .init(title: "킥보드/자전거 거의 없음", isSelected: false),
        .init(title: "차량 거의 없음", isSelected: false),
        .init(title: "야간에도 밝음", isSelected: false),
        .init(title: "보도/차도 구분됨", isSelected: false),
        .init(title: "넓은 보도", isSelected: false),
    ]
    
    @Published var convenienceList: [CheckOption] = [
        .init(title: "배변 봉투 쓰레기통", isSelected: false),
        .init(title: "벤치", isSelected: false),
        .init(title: "편의점", isSelected: false),
        .init(title: "반려견 동반 카페", isSelected: false),
    ]
    
    @Published var environmentList: [CheckOption] = [
        .init(title: "풀 많은 길 위주", isSelected: true),
        .init(title: "흙길 위주", isSelected: false),
        .init(title: "아스팔트/벽돌길 위주", isSelected: false),
        .init(title: "뛰어놀 공간", isSelected: false),
    ]
    
    @Published var moodList: [CheckOption] = [
        .init(title: "조용한 분위기", isSelected: true),
        .init(title: "적당한 유동인구", isSelected: false),
        .init(title: "유동 인구 많음", isSelected: false),
    ]
    
    func selectWalkRouteOption(_ option: WalkRouteOption) {
        switch option {
        case .walkingTime(let index):
            walkingTimeList = selecteMultipleOption(at: index, from: walkingTimeList)
        case .safety(let index):
            safetyList = selecteMultipleOption(at: index, from: safetyList)
        case .convenience(let index):
            convenienceList = selecteMultipleOption(at: index, from: convenienceList)
        case .environment(let index):
            environmentList = selecteSingleOption(at: index, from: environmentList)
        case .mood(let index):
            moodList = selecteSingleOption(at: index, from: moodList)
        }
    }
    
    func resetAllOptions() {
        walkingTimeList = walkingTimeList.map { .init(title: $0.title, isSelected: false)}
        safetyList = safetyList.map { .init(title: $0.title, isSelected: false)}
        convenienceList = convenienceList.map { .init(title: $0.title, isSelected: false)}
        environmentList = environmentList.map { .init(title: $0.title, isSelected: false)}
        moodList = moodList.map { .init(title: $0.title, isSelected: false)}
        isExpandWalkingTime = false
        isExpandSafety = false
        isExpandConvenience = false
        isExpandEnvironment = false
        isExpandMood = false
    }
    
    private func selecteSingleOption(at index: Int, from list: [CheckOption]) -> [CheckOption] {
        guard let findIndex = list.firstIndex(where: {$0.isSelected}) else { return [] }
        var newList = list
        newList[findIndex].isSelected = false
        newList[index].isSelected = true
        return newList
    }
    
    private func selecteMultipleOption(at index: Int, from list: [CheckOption]) -> [CheckOption] {
        var newList = list
        newList[index].isSelected.toggle()
        return newList
    }
}
