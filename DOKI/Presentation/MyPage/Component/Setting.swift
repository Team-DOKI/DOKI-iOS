//
//  Setting.swift
//  DOKI
//
//  Created by 안치욱 on 12/29/25.
//

import SwiftUI

struct Setting: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("설정")
                    .small(color: .defaultDark)
                
                Spacer()
            }
            .frame(height: 32)
            .padding(.horizontal, 16)
            
            Button {
                print("활동 범위 설정")
            } label: {
                HStack(spacing: 8) {
                    Image(.icLocation)
                    
                    Text("활동 범위 설정")
                        .bodyDefault()
                    
                    Spacer()
                    
                    Image(.btnMore)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .frame(height: 56)
            
            Button {
                print("앱 정보")
            } label: {
                HStack(spacing: 8) {
                    Image(.icInfo)
                    
                    Text("앱 정보")
                        .bodyDefault()
                    
                    Spacer()
                    
                    Image(.btnMore)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .frame(height: 56)
            
            Button {
                print("로그아웃")
            } label: {
                HStack(spacing: 8) {
                    Image(.icLogout)
                    
                    Text("로그아웃")
                        .bodyDefault()
                    
                    Spacer()
                    
                    Image(.btnMore)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .frame(height: 56)
            
            Button {
                print("탈퇴하기")
            } label: {
                HStack(spacing: 8) {
                    Image(.icQuit)
                    
                    Text("탈퇴하기")
                        .bodyDefault()
                    
                    Spacer()
                    
                    Image(.btnMore)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .frame(height: 56)
        }
        .background(.defaultBackground)
        .cornerRadius(8)
    }
}
