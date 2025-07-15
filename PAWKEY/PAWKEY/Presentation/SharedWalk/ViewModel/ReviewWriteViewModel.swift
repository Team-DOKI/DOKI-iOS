//
//  ReviewWriteViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/14/25.
//

import SwiftUI
import Moya

class ReviewWriteViewModel: ObservableObject {
    private let provider = MoyaProvider<ReviewWriteAPI>()
    
    @Published var categories: [CategoryList] = []
    @Published var selectedOptions: [Int: Set<String>] = [:]
    
    
    var isButtonDisabled: Bool {
        selectedOptions.values.allSatisfy { !$0.isEmpty }
    }
    
    @MainActor
    func fetchCourseCategories() async {
        do {
            let response: BaseDTO<CategoryDTO> = try await provider.async.request(ReviewWriteAPI.fetchCourseCategories)
            
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
