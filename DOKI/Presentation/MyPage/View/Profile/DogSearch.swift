//
//  DogSearch.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

// TODO: 중복 컴포넌트 분리
struct DogSearch: View {
    @ObservedObject var viewModel: PetProfileViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("견종 검색")
                .subtitle()
                .padding(.vertical, 25)
            
            SearchField(placeholder: "견종을 검색해보세요", text: $viewModel.breedSearchText)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.breedList, id: \.self) { breed in
                        OptionItem(text: breed, isChecked: viewModel.breed == breed) {
                            viewModel.selectBreed(breed)
                            viewModel.toggleBreedSearchSheet()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
