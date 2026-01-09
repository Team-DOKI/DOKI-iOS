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
    var isChecked: Bool
}

struct WalkView: View {
    @StateObject var viewModel: WalkViewModel
    
    @State private var items: [WalkItem] = [
        WalkItem(name: "배변 봉투", isChecked: false),
        WalkItem(name: "리드줄", isChecked: true),
        WalkItem(name: "물", isChecked: true),
        WalkItem(name: "간식", isChecked: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("오늘의 산책 TIP")
                        .font(.small)
                        .foregroundStyle(.defaultMiddle)
                    
                    Text("발이 차가워요.. 잠깐 다녀와요!")
                        .font(.subtitle)
                        .foregroundColor(.contents)
                    
                    Text("10분 내 짧은 산책 / 패딩과 신발 필수")
                        .font(.bodySmall)
                        .foregroundColor(.contents)
                }
                .padding(.vertical, 17)
                .padding(.leading, 22)
                
                Spacer()
                
                //                Image(.imgWalkdog)
            }
            .frame(maxWidth: .infinity)
            .background(.defaultBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(.defaultPrimary, lineWidth: 1)
            )
            .padding(.top, 16)
            .padding(.horizontal, 15)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("산책 필수템")
                    .font(.subtitle)
                    .foregroundColor(.defaultDark)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach($items) { $item in
                        HStack(spacing: 8) {
                            Button {
                                item.isChecked.toggle()
                            } label: {
                                Image(item.isChecked ? .btnCheck : .btnUncheck)
                            }
                            
                            Text(item.name)
                                .font(.subDefault)
                                .foregroundColor(item.isChecked ? .defaultDark : .defaultMiddle)
                            
                            Spacer()
                            
                            Image(.btnX)
                        }
                        .padding(.vertical, 8)
                        
                        Divider()
                            .background(.defaultBright)
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
            
            Spacer()
            
            MainButton(text: "산책 기록 시작하기", buttonState: .active2) {
                viewModel.navigateToWalkRecord()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 25)
        }
        .background(.defaultBright)
        .topNavigationView(center: {
            Text("산책")
                .subtitle()
        })
    }
}
