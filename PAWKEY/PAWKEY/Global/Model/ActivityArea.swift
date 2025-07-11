//
//  ActivityArea.swift
//  PAWKEY
//
//  Created by 권석기 on 7/11/25.
//

import Foundation
import MapKit

struct ActivityArea: Identifiable {
    let id = UUID()
    let coordinates: [[CLLocationCoordinate2D]]
}
