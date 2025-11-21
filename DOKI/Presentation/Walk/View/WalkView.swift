//
//  WalkView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkItem: Identifiable {
    let id = UUID()
    let name: String
    var isOn: Bool
}

struct WalkView: View {
    @StateObject var viewModel: WalkViewModel
    
    @State private var items: [WalkItem] = [
        WalkItem(name: "배변 봉투", isOn: true),
        WalkItem(name: "리드줄", isOn: true),
        WalkItem(name: "물", isOn: true),
        WalkItem(name: "간식", isOn: true)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image("")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .background(.primaryGra1)
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("숨이 얼어붙어요… 오늘은 나가지말아요")
                        .font(.bodyBold)
                        .foregroundColor(.defaultBackground)
                    Text("실외 금지! 실내 놀이로 대체")
                        .font(.subDefault)
                        .foregroundColor(.defaultBright)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.defaultPrimary)
            .cornerRadius(16)
            .padding(.top, 20)
            .padding(.horizontal, 16)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("산책 필수템")
                    .font(.subtitle)
                    .foregroundColor(.defaultDark)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach($items) { $item in
                        HStack(spacing: 8) {
                            Button {
                                item.isOn.toggle()
                            } label: {
                                Image(systemName: item.isOn ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(item.isOn ? .green : .gray)
                            }
                            
                            Text(item.name)
                                .font(.subDefault)
                                .foregroundColor(.defaultMiddle)
                        }
                        .padding(8)
                        .background(.defaultButton)
                        .cornerRadius(8)
                    }
                }
                
                Button {
                } label: {
                    Text("+ 추가하기")
                        .font(.subActive)
                        .foregroundColor(.defaultPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(.primaryGra1)
                        .cornerRadius(8)
                }
            }
            .padding(16)
            .background(.defaultBackground)
            .cornerRadius(16)
            .padding(16)
            
            Button {
                viewModel.navigateToWalkRecord()
            } label: {
                Text("산책 기록 시작하기")
                    .foregroundColor(.defaultPrimary)
                    .font(.mainActive)
                    .frame(maxWidth: .infinity)
                    .padding(19)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(.defaultPrimary, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .background(.defaultBright)
        .topNavigationView(center: {
            Text("산책")
                .subtitle()
        })
    }
}
