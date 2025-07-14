//
//  MyCourseViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

final class MyCourseViewModel: ObservableObject {
    let tagList = ["이륜차 거의 없음", "배변 쓰레기통", "쉼터", "편의점", "동반 카페", "아스팔트/벽돌", "시끌벅적"]
    let myReviewList: [Review] = [
        Review(walkRouteImg: "walkRoute", profileImg: "profile6", walkTitle: "아시는구나~", petName: "포키", postDate: "2025/01/02", buttonPressed: true),
        Review(walkRouteImg: "walkRoute2", profileImg: "profile2", walkTitle: "신나는 산책", petName: "쮸비", postDate: "2025/03/04", buttonPressed: false),
        Review(walkRouteImg: "walkRoute3", profileImg: "profile3", walkTitle: "더운 산책", petName: "수민이누나", postDate: "2025/05/06", buttonPressed: true),
        Review(walkRouteImg: "walkRoute", profileImg: "profile4", walkTitle: "스꾸삐~", petName: "세민이", postDate: "2025/07/08", buttonPressed: false),
        Review(walkRouteImg: "walkRoute2", profileImg: "profile5", walkTitle: "그냥 산책", petName: "치즈", postDate: "2025/09/10", buttonPressed: false)
    ]
}
