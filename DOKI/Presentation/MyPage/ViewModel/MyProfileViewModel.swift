//
//  MyProfileViewModel.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

class MyProfileViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var birthDay: String = ""
    @Published var gender: Gender?
    
    func selecteGender(_ gender: Gender) {
        self.gender = gender
    }
    
    func saveButtonTapped() {
        
    }
}
