//
//  ActivityAreaMapView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI
import MapKit

struct ActivityAreaMapView: View {
    @EnvironmentObject var router: TabRouter<HomeScreen>
    @EnvironmentObject var tabBarState: TabBarState
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5172, longitude: 127.0473),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Color.pawkeyWhite1
                    .frame(height: 246)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .overlay(
                        VStack(alignment: .leading) {
                            HStack {
                                Text("선택한 위치")
                                    .font(.head_20_b)
                                    .foregroundColor(.pawkeyBlack)
                                Spacer()
                                Text("역삼동")
                                    .font(.head_20_b)
                                    .foregroundColor(.green500)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 32)
                            .padding(.bottom, 18)
                            
                            Text("기존에 산책하던 지역은 0000이에요.\n선택한 위치로 산책 지역을 변경하시겠어요?")
                                .font(.body_14_m)
                                .foregroundColor(.gray500)
                                .padding(.top, 12)
                                .padding(.horizontal, 16)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            CTAButton(title: "지역 변경하기") {
                                
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 32)
                            .padding(.bottom, 30)
                        }
                    )
            }
        }
        .topNavigationView(left: {
            BackButton {
                router.pop()
            }
        }, center: {
            Text("내 동네 설정")
                .font(.body_16_sb)
        })
    }
    
    //        .onAppear {
    //            withAnimation {
    //                tabBarState.isHidden = true
    //            }
    //        }
}
