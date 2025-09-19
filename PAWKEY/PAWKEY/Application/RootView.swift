//
//  RootView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

struct RootView: View {
    //    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @State var breeds = [
        Breed(name: "닥스훈트"),
        Breed(name: "달마시안"),
        Breed(name: "말라뮤트"),
        Breed(name: "말티즈"),
        Breed(name: "믹스견"),
    ]
    var body: some View {
        VStack {
            HStack {
                CheckBox(text: "남아", isChecked: true)
                CheckBox(text: "여아", isChecked: false)
            }
            MainTextField(placeholder: "text", text: .constant(""))
            SearchField(placeholder: "text", text: .constant(""))
            
            ScrollView {
                ForEach(breeds.indices, id: \.self) { index in
                    BreedItem(text: breeds[index].name, isChecked: breeds[index].isChecked) {
                        breeds.indices.forEach { breeds[$0].isChecked = false }
                        breeds[index].isChecked = true
                    }
                }
            }
        }
        .padding()
    }
}

struct Breed: Hashable {
    let name: String
    var isChecked: Bool = false
}
