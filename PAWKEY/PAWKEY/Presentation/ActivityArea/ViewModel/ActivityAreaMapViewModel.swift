//
//  ActivityAreaMapViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI
import MapKit

final class ActivityAreaMapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5215, longitude: 127.0250),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )    
    @Published var activityAreas: [ActivityArea] = []
    @Published var isShowToast = false
}
