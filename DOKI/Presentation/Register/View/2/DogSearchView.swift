//
//  DogSearchView.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct DogSearchView: View {
    let breeds: [BreedList]
    let selectedBreedName: String
    
    @Binding var searchText: String
    
    let onSelect: (BreedList) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("견종 검색")
                .subtitle()
                .padding(.vertical, 25)
            
            SearchField(placeholder: "견종을 검색해보세요", text: $searchText)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            ScrollView {
                LazyVStack {
                    ForEach(filteredBreeds, id: \.id) { breed in
                        OptionItem(text: breed.name, isChecked: selectedBreedName == breed.name) {
                            onSelect(breed)
                            onDismiss()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var filteredBreeds: [BreedList] {
        if searchText.isEmpty { return breeds }
        return breeds.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
