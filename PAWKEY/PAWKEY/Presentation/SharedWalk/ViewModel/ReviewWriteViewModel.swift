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
    
    let routeId: Int
    
    init(routeId: Int) {
        self.routeId = routeId
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
    
    @MainActor
    func postReview(routeId: Int) async {
        let selectedReviewCategories: [ReviewCategory] = categories.compactMap { category in
            guard let selectedTexts = selectedOptions[category.categoryId], !selectedTexts.isEmpty else {
                return nil
            }
            
            let optionIds = category.categoryOptions
                .filter { selectedTexts.contains($0.categoryOptionText) }
                .map { $0.categoryOptionId }
            
            return ReviewCategory(
                reviewCategoryId: category.categoryId,
                selectedReviewOptionIds: optionIds
            )
        }
        
        let body = ReviewWriteDTO(
            routeId: routeId,
            selectedReviewCategory: selectedReviewCategories
        )
        
        do {
            try await provider.async.requestPlain(ReviewWriteAPI.postReview(body: body))
            print(/*"리뷰 업로드 성공"*/ body.routeId)
        } catch {
            print("리뷰 업로드 실패: \(error.localizedDescription)")
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
