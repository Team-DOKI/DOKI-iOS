//
//  WalkRecordView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI
import NMapsMap

struct WalkRecordView: View {
    @StateObject var viewModel: WalkRecordViewModel
    
    @State private var isLocationOn = false
    @State private var showFinishConfirmation = false
    
    var body: some View {
        ZStack() {
            NaverMap()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 위치 공유
                HStack(spacing: 0) {
                    Spacer()
                    
                    Toggle("", isOn: $isLocationOn)
                        .labelsHidden()
                        .padding(.trailing, 16)
                }
                .padding(.top, 20)
                .opacity(0)
                
                
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        PinButton(icon: "ic_trash", action: {}).opacity(0) // 스팟 태그
                        PinButton(icon: "ic_photo", action: {}).opacity(0) // 스팟 태그
                        PinButton(icon: "ic_gps", action: {})
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 14)
                
                VStack(spacing: 12) {
                    Spacer().frame(height: 44)
                    
                    HStack(spacing: 0) {
                        StatItem(title: "거리 (km)", value: "2.2")
                        StatItem(title: "시간 (분)", value: "30:00")
                        StatItem(title: "걸음 수 (걸음)", value: "12345")
                    }
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 8) {
                        MainButton(text: "산책 중단하기", buttonState: .active2, font: .subtitle)
                        
                        MainButton(text: "산책 종료하기", buttonState: .active1, font: .subtitle) {
                            showFinishConfirmation = true
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
                .background(.defaultBackground)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .shadow(color: .contents.opacity(0.15), radius: 6, x: 0, y: -2)
            }
            .ignoresSafeArea(edges: .bottom)
            
            if showFinishConfirmation {
                Color.contents.opacity(0.75)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("산책이 중단되었어요")
                            .font(.header2)
                            .foregroundColor(.defaultBackground)
                        
                        Text("산책을 정말 종료하시겠어요?")
                            .font(.subtitle)
                            .foregroundColor(.defaultBackground)
                    }
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        MainButton(text: "산책 중단하기", buttonState: .active2, font: .subtitle) {
                            withAnimation {
                                showFinishConfirmation = false
                            }
                        }
                        
                        MainButton(text: "산책 종료하기", buttonState: .active1, font: .subtitle) {
                            viewModel.navigateToWalkResult()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
                .transition(.opacity)
                .ignoresSafeArea()
            }
        }
    }
}

struct NaverMap: UIViewRepresentable {
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        mapView.positionMode = .compass
        
        return mapView
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {}
}

