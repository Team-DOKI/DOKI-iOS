//
//  RouteCell.swift
//  DOKI
//
//  Created by a on 11/2/25.
//

import SwiftUI

import Kingfisher

struct RouteCell: View {
    let post: PostItem
    let likeAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            KFImage(URL(string: post.imageUrl))
                .placeholder {
                    Image(.imgDefaultpost)
                        .resizable()
                }
                .resizable()
                .frame(height: 212)
                .cornerRadius(8)
                .overlay(alignment: .top) {
                    HStack(spacing: 0) {
                        AddressTag(text: post.regionName)
                        
                        Spacer()
                        
                        Button {
                            likeAction()
                        } label: {
                            if post.isLiked {
                                Image(.btnRedheart)
                            } else {
                                Image(.btnGrayheart)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(8)
                }
            
            Text(post.title)
                .bodyBold()
                .padding(.top, 8)
                .padding(.horizontal, 2)
            
            HStack(spacing: 0) {
                HStack(spacing: 4) {
                    Image(.icCalendar)
                    
                    Text(post.date.formattedToYYMMDD("yy/MM/dd"))
                        .small(color: .defaultMiddle)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(.icClock)
                    
                    Text(post.durationText)
                        .small(color: .defaultMiddle)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 2)
        }
    }
}
