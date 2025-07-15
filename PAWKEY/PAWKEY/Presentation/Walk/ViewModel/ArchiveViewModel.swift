//
//  ArchiveViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/9/25.
//

import SwiftUI
import PhotosUI

class ArchiveViewModel: ObservableObject {
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedImages: [UIImage] = []
    
    @Published var safetyTags: Set<String> = []
    @Published var facilityTags: Set<String> = []
    
    @Published var titleText: String = ""
    @Published var reviewText: String = ""
    
    var snapshot: UIImage?
    
    var isButtonDisabled: Bool {
        !titleText.trimmingCharacters(in: .whitespaces).isEmpty &&
        !reviewText.trimmingCharacters(in: .whitespaces).isEmpty &&
        !safetyTags.isEmpty &&
        !facilityTags.isEmpty
    }
    
    @MainActor
    func loadImagesFromPicker() async {
        var newImages: [UIImage] = []
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                newImages.append(uiImage)
            }
        }
        
        selectedImages.append(contentsOf: newImages)
        selectedItems = []
    }
}
