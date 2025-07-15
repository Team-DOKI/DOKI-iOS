//
//  ArchiveViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/9/25.
//

import SwiftUI
import PhotosUI
import Moya

class ArchiveViewModel: ObservableObject {
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedImages: [UIImage] = []
    
    @Published var location: String = ""
    @Published var time: String = ""
    @Published var petName: String = ""
    
    @Published var descriptionTags: [String] = []
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
    
    private let provider = MoyaProvider<ArchiveAPI>().async
    
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
    
    @MainActor
    func fetchCourseInfo(routeId: Int) async {
        do {
            let response: BaseDTO<ArchiveInfoDTO> = try await provider.request(ArchiveAPI.fetchCourseInfo(routeId: routeId))
            if let data = response.data {
                self.location = data.routeDto.locationDescription
                self.time = data.routeDto.dateDescription
                self.descriptionTags = data.routeDto.descriptionTags
                self.petName = data.petName
                
                print("\(response.message)")
                print("""
                            
                            위치: \(self.location)
                            시간: \(self.time)
                            태그: \(self.descriptionTags.joined(separator: ", "))
                            강아지 이름: \(self.petName)
                            """)
            }
        } catch {
            print("정보 불러오기 실패: \(error)")
        }
    }
}
