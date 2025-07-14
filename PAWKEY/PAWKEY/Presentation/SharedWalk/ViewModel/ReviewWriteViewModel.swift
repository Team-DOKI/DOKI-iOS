//
//  ReviewWriteViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/14/25.
//

import SwiftUI

class ReviewWriteViewModel: ObservableObject {
    @Published var safetyTags: Set<String> = []
    @Published var facilityTags: Set<String> = []
    
    var isButtonDisabled: Bool {
        !safetyTags.isEmpty &&
        !facilityTags.isEmpty
    }
}
