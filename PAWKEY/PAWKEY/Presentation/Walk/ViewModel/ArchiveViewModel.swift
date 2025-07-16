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
    private let provider = MoyaProvider<ArchiveAPI>()
    
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedImages: [UIImage] = []
    
    @Published var location: String = ""
    @Published var time: String = ""
    @Published var petName: String = ""
    @Published var descriptionTags: [String] = []
    
    @Published var categories: [CategoryList] = []
    @Published var selectedOptions: [Int: Set<String>] = [:]
    
    @Published var titleText: String = ""
    @Published var reviewText: String = ""
    
    @Published var postId: Int = 0
    
    var snapshot: UIImage?
    
    var isButtonDisabled: Bool {
        !titleText.trimmingCharacters(in: .whitespaces).isEmpty &&
        !reviewText.trimmingCharacters(in: .whitespaces).isEmpty &&
        selectedOptions.values.allSatisfy { !$0.isEmpty }
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

extension ArchiveViewModel {
    @MainActor
    func fetchCourseInfo(routeId: Int) async {
        do {
            let response: BaseDTO<ArchiveInfoDTO> = try await provider.async.request(ArchiveAPI.fetchCourseInfo(routeId: routeId))
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
    
    @MainActor
    func fetchCourseCategories() async {
        do {
            let response: BaseDTO<CategoryDTO> = try await provider.async.request(ArchiveAPI.fetchCourseCategories)
            
            if let data = response.data {
                self.categories = data.categoryList
                for category in data.categoryList {
                    selectedOptions[category.categoryId] = []
                }
                
                print("\(response.message)")
            }
        } catch {
            print("카테고리 불러오기 실패: \(error)")
        }
    }
}

extension ArchiveViewModel {
    func categoryOptionTexts(_ categoryId: Int) -> [String] {
        categories.first(where: { $0.categoryId == categoryId })?.categoryOptions.map { $0.categoryOptionText } ?? []
    }
    
    func selectedOptionsBinding(_ categoryId: Int) -> Binding<Set<String>> {
        Binding(
            get: { self.selectedOptions[categoryId] ?? [] },
            set: { self.selectedOptions[categoryId] = $0 }
        )
    }
}

extension ArchiveViewModel {
    @MainActor
    func uploadCourse(isPublic: Bool) async {
        let selectedCategoryOptions = selectedOptions.map { categoryId, selectedTexts in
            let optionIds = categories
                .first(where: { $0.categoryId == categoryId })?
                .categoryOptions
                .filter { selectedTexts.contains($0.categoryOptionText) }
                .map { $0.categoryOptionId } ?? []
            
            return SelectedCategoryOptions(categoryId: categoryId, selectedOptionIds: optionIds)
        }
        
        let body = ArchivePostDTO(
            title: titleText,
            description: reviewText,
            isPublic: isPublic,
            selectedOptionsForCategories: selectedCategoryOptions,
            routeId: 54
        )
        
        let imageDatas = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        
        do {
            let response: BaseDTO<ArchiveResponseDTO> = try await provider.async.request(
                ArchiveAPI.postCourse(body: body, images: imageDatas)
            )
            
            print("\(response.message)")
            
            
            guard let postId = response.data?.postId else  {
                return
            }
            self.postId = postId
            
            print("postId: \(postId)")
            
        } catch {
            print("업로드 실패: \(error.localizedDescription)")
        }
    }
}
