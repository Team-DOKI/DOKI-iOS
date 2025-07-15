//
//  ActivityAreaMapViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import MapKit
import Moya

class ActivityAreaMapViewModel: ObservableObject {
    private let provider = MoyaProvider<ActivityAreaMapAPI>()
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5215, longitude: 127.0250),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    )
    @Published var activityAreas: [ActivityArea] = []
    @Published var preRegionName: String = ""
    @Published var regionName: String = ""
    
    @Published var isShowToast = false
    
    @MainActor
    func fetchActivityArea(regionId: Int) async {
        do {
            let response: BaseDTO<RegionDTO> = try await provider.async.request(.fetchCoordinates(regionId: regionId))
            
            guard let data = response.data else {
               print("데이터 없음")
                return
            }
            print("\(response.message): \(data.regionName) 조회, 기존 산책 지역: \(data.preRegionName)")
            
            self.preRegionName = data.preRegionName.components(separatedBy: " ").last ?? data.preRegionName
            self.regionName = data.regionName.components(separatedBy: " ").last ?? data.regionName
            
            let coords = data.geometryDto.coordinates.map { polygon in
                polygon.map { ring in
                    ring.map { point in
                        CLLocationCoordinate2D(latitude: point[1], longitude: point[0])
                    }
                }
            }
            
            activityAreas = coords.map { ActivityArea(coordinates: $0) }
            
            if let first = coords.first?.first?.first {
                region.center = first
            }
        } catch {
            print("에러 발생: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func updateUserRegion(regionId: Int) async {
        do {
            try await provider.async.requestPlain(.updateUserRegion)
            print("요청 처리 성공: 지역 변경 성공")
            
            self.isShowToast = true
        } catch {
            print("지역 변경 실패: \(error.localizedDescription)")
        }
    }
}
