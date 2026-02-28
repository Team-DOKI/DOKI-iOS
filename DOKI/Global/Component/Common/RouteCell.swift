//
//  RouteCell.swift
//  DOKI
//
//  Created by a on 11/2/25.
//

import SwiftUI

struct RouteCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("")
                .resizable()
                .frame(width: 167, height: 212)
                .background(.defaultButton)
                .cornerRadius(8)
                .overlay(alignment: .top) {
                    HStack(spacing: 0) {
                        AddressTag(text: "강남구 역삼동")
                        
                        Spacer()
                        
                        Image(.btnRedheart)
                    }
                    .padding(8)
                }
            
            Text("오늘도 단지랑 룰루랄라")
                .bodyBold()
                .padding(.top, 8)
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(.icCalendar)
                    Text("2025/09/19")
                        .small(color: .defaultMiddle)
                }
                
                HStack(spacing: 4) {
                    Image(.icClock)
                    Text("30min")
                        .small(color: .defaultMiddle)
                }
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        RouteCell()
        RouteCell()
    }
    .padding()
}
