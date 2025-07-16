//
//  UserProfile.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//


import Foundation
import SwiftUI

struct MyUserProfile {
    let name: String
    let gender: String
    let age: Int
    let region: String

    init(dto: MyUserProfileDTO) {
        self.name = dto.name
        self.gender = dto.gender
        self.age = dto.age
        self.region = dto.activeRegion
    }
}
