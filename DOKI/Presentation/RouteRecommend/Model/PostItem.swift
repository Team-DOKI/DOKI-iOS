//
//  PostItem.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

struct PostItem {
    let postId: Int
    let regionName: String
    let title: String
    let date: String
    let isLiked: Bool
    let imageUrl: String
    let durationMinutes: Int
    
    var durationText: String {
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60
        return hours == 0 ? "\(minutes)m" : "\(hours)h\(minutes)m"
    }
}
