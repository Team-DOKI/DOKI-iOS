//
//  RouteCell.swift
//  DOKI
//
//  Created by a on 11/2/25.
//

import SwiftUI

struct RouteCell: View {
    let route: RouteInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: route.imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(width: 167, height: 212)
            .cornerRadius(8)
            .overlay(alignment: .top) {
                HStack(spacing: 0) {
                    AddressTag(text: route.address)
                    
                    Spacer()
                    
                    if route.isLiked {
                        Image(.btnRedheart)
                    } else {
                        Image(.btnGrayheart)
                    }
                }
                .padding(8)
            }
            
            Text(route.title)
                .bodyBold()
                .padding(.top, 8)
                .padding(.horizontal, 2)
            
            HStack(spacing: 0) {
                HStack(spacing: 4) {
                    Image(.icCalendar)
                    
                    Text(route.date)
                        .small(color: .defaultMiddle)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(.icClock)
                    
                    Text(route.duration)
                        .small(color: .defaultMiddle)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 2)
        }
    }
}
