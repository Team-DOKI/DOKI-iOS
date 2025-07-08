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
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("탭", selection: $selectedMode) {
                Text("지도").tag(0)
                Text("리스트").tag(1)
            }
            .pickerStyle(.segmented)
            .frame(height: 64)
            .padding(.horizontal)
            
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
                                Button("산책 기록 시작하기") {
                                    showWalkCourseView = true
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        viewModel.centerMapOnCurrentLocation()
                                        shouldCenterOnUser = true
                                    }) {
                                        Image(systemName: "location.fill")
                                            .frame(width: 44, height: 44)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                            .shadow(radius: 2)
                                    }
                                    .padding(.trailing, 16)
                                }
                            }
                            .padding(.bottom, 96)
                        },
                        alignment: .bottom
                    )
                    
                    Text(currentAddress)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(.white)
                        .foregroundColor(.green)
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
