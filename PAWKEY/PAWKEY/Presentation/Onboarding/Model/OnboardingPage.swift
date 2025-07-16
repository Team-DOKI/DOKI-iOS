//
//  OnboardingPage.swift
//  PAWKEY
//
//  Created by 이세민 on 7/16/25.
//

import Foundation

struct OnboardingPage {
    let imageName: String
    let title: String
    let subtitle: String?
    let highlight: String?
    
    init(imageName: String, title: String, subtitle: String? = nil, highlight: String? = nil) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.highlight = highlight
    }
}
