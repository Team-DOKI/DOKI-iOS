//
//  RouteDetailViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

// TODO: - 위치 고민
enum RouteDetailRoute {
    case back
    case followRoute(routeId: Int)
}

class RouteDetailViewModel: ObservableObject {
    var routeId: Int = 0
    
    @Published var address: String = "상세 주소"
    @Published var recordDate: String = "YY.MM.DD | 오후 00:00"
    @Published var walkRecord: String = "거리 | 시간 | 걸음수"
    @Published var tagList: [String] = ["혼잡도 보통", "교류 활발", "보도/차도 분리", "보도 넓음", "킥보드/자전거 적음", "야간 밝음", "벤치", "배변 봉투 쓰레기통", "편의점", "반려견 동반 카페", "잔디길", "흙길", "포장길", "놀이터/공터"]
    @Published var isExpanded: Bool = false
    
    //MARK: - Navigation
    
    var navigationAction: ((RouteDetailRoute)->())?
    
    func setRouteId(routeId: Int) {
        self.routeId = routeId
    }
    
    func navigateToBack() {
        navigationAction?(.back)
    }
    
    func navigateToFollowRouteFollowRoute() {
        navigationAction?(.followRoute(routeId: routeId))
    }
}
