//
//  CourseDetailViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/9/25.
//

import SwiftUI

class CourseDetailViewModel: ObservableObject, Hashable {
    static func == (lhs: CourseDetailViewModel, rhs: CourseDetailViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    
    @Published var images: [UIImage] = []
    @Published var isPrivate: Bool = false
    @Published var selectedImage: UIImage?
    @Published var isShowPhotoPreview = false
    @Published var isShowContextMenu = false
}
