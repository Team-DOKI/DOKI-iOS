//
//  ActivityAreaMapViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import MapKit
import Moya

class ActivityAreaMapViewModel: ObservableObject {    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5215, longitude: 127.0250),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var activityAreas: [ActivityArea] = []
    @Published var regionName: String = ""
    @Published var errorMessage: String?
    @Published var isShowToast = false
    
    private let provider = MoyaProvider<ActivityAreaMapAPI>()
    
    func fetchActivityArea(regionId: Int) async {
        do {
            let response: BaseDTO<RegionDTO> = try await provider.async.request(.fetchCoordinates(regionId: regionId))
            
            guard let data = response.data else {
                errorMessage = "데이터 없음"
                return
            }
            print("\(response.message): \(data.regionName)")
            
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
            errorMessage = "에러 발생: \(error.localizedDescription)"
        }
    }
    
    func updateUserRegion(regionId: Int) async {
        do {
            let response: BaseDTO<EmptyDTO> = try await provider.async.request(.updateUserRegion(regionId: regionId))
            
            print("\(response.message): 지역 변경 성공")
            
            DispatchQueue.main.async {
                self.isShowToast = true
            }
            
        } catch {
            errorMessage = "지역 변경 실패: \(error.localizedDescription)"
        }
    }
}
