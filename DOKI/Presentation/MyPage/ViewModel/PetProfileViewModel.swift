//
//  PetProfileViewModel.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

class PetProfileViewModel: ObservableObject {
    @Published var dogName = ""
    @Published var dogBirthDay = ""
    @Published var dogGender: Gender?
    @Published var breed = ""
    @Published var isNeutering = false
    @Published var profileImage: [UIImage] = []
    @Published var isShowBreedSearch = false
    @Published var breedSearchText = ""
    
    @Published var breedList: [String] = [
        "말티즈",
        "포메라니안",
        "푸들",
        "시츄",
        "치와와",
        "골든 리트리버",
        "래브라도 리트리버",
        "시베리안 허스키",
        "요크셔 테리어",
        "보더콜리"
    ]
    
    func selectDogGender(_ gender: Gender) {
        self.dogGender = gender
    }
    
    func toggleIsNeutering() {
        isNeutering.toggle()
    }
    
    func toggleBreedSearchSheet() {
        isShowBreedSearch.toggle()
    }
    
    func selectBreed(_ breed: String) {
        self.breed = breed
    }
}
