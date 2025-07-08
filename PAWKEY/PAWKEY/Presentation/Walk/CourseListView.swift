//
//  CourseListView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import CoreLocation

struct CourseListView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    
    @StateObject private var viewModel = WalkCourseViewModel()
    
    @State private var selectedMode: Int = 0
    @State private var showWalkCourseView = false
    @State private var shouldCenterOnUser: Bool = false
    @State private var currentAddress: String = ""
    
    let tabs: [(title: String, mode: Int)] = [("지도", 0), ("리스트", 1)]
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(tabs, id: \.mode) { tab in
                    Button {
                        selectedMode  = tab.mode
                    } label: {
                        VStack(spacing: 4) {
                            Text(tab.title)
                                .font(.head_22_b)
                                .foregroundColor(selectedMode == tab.mode ? .pawkeyBlack : .gray200)
                            
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(selectedMode == tab.mode ? .pawkeyBlack : .clear)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(width: 155, height: 56)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.leading, 16)
            
            if selectedMode == 0 {
                ZStack(alignment: .topLeading) {
                    WalkingMapView(region: $viewModel.region,
                                   pathCoordinates: $viewModel.pathCoordinates,
                                   shouldCenterOnUser: $shouldCenterOnUser)
                    .edgesIgnoringSafeArea(.bottom)
                    .overlay(
                        VStack {
                            Spacer()
                            
                            ZStack {
                                Button {
                                    showWalkCourseView = true
                                } label: {
                                    Text("산책 기록 시작하기")
                                        .font(.body_16_sb)
                                        .foregroundColor(.pawkeyWhite1)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(.green500)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        viewModel.centerMapOnCurrentLocation()
                                        shouldCenterOnUser = true
                                    }) {
                                        Image(.mapGps)
                                    }
                                    .padding(.trailing, 16)
                                }
                            }
                            .padding(.bottom, 98)
                        },
                        alignment: .bottom
                    )
                    
                    Text(currentAddress)
                        .font(.body_16_sb)
                        .foregroundColor(.green500)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(.pawkeyWhite1)
                        .cornerRadius(60)
                        .padding(.top, 18)
                        .padding(.leading, 16)
                }
            } else {
                Button("ㅋㅋ") {
                    router.push(.sharedWalkCourse(id: 1))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            viewModel.requestPermission()
            fetchAddress()
        }
        .fullScreenCover(isPresented: $showWalkCourseView) {
            WalkCourseView(viewModel: viewModel, showWalkCourseView: $showWalkCourseView){ distance, elapsedTime, stepCount in
                router.push(.walkCompletion(
                    distance: distance,
                    elapsedTime: elapsedTime,
                    stepCount: stepCount
                ))
                viewModel.resetTrackingData()
            }
        }
    }
    
    func fetchAddress() {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: viewModel.region.center.latitude,
                                  longitude: viewModel.region.center.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                self.currentAddress = "주소 오류"
                return
            }
            
            let dong = placemark.subLocality ?? ""
            var gu = placemark.subAdministrativeArea ?? ""
            
            if gu.isEmpty {
                let debugDescription = placemark.debugDescription
                let pattern = #"대한민국.*?,"#
                if let regex = try? NSRegularExpression(pattern: pattern) {
                    let range = NSRange(debugDescription.startIndex..<debugDescription.endIndex, in: debugDescription)
                    if let match = regex.firstMatch(in: debugDescription, options: [], range: range) {
                        let matched = (debugDescription as NSString).substring(with: match.range)
                        let parts = matched.split(separator: " ")
                        if parts.count >= 3 {
                            gu = String(parts[2])
                        }
                    }
                }
            }
            
            if !gu.isEmpty && !dong.isEmpty {
                self.currentAddress = "\(gu) \(dong)"
            } else if !dong.isEmpty {
                self.currentAddress = dong
            } else {
                self.currentAddress = "주소 없음"
            }
        }
    }
}
