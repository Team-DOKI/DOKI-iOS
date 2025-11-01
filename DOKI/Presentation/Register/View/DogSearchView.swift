//
//  DogSearchView.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct DogSearchView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack {
            Text("견종 검색")
                .subtitle()
                .frame(height: 54, alignment: .center)
            
            SearchField(placeholder: "견종을 검색해보세요", text: $viewModel.breedSearchText)
                .padding(.horizontal, 16)
            
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
