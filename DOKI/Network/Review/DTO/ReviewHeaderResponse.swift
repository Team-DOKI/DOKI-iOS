//
//  ReviewHeaderResponse.swift
//  DOKI
//
//  Created by 이세민 on 4/16/26.
//

import Foundation

struct ReviewHeaderResponse: Codable {
    let postTitle: String
    let reviewerProfile: ReviewerProfile

    struct ReviewerProfile: Codable {
        let profileName: String
        let profileImageUrl: String
    }
}
