//
//  PetProfile.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/15/25.
//

import Foundation

struct PetProfile: Hashable {
    let petID: Int
    let name, gender: String
    var isNeutered: Bool
    let age: Int
    var isAgeKnown: Bool
    let breed, imageURL: String
    let traits: [PetTraitOption]
    var walkCount: Int
}

struct PetTraitOption: Hashable {
    let category, option: String
}

extension PetProfile {
    init(dto: PetProfileDetailDTO) {
        self.petID = dto.petID
        self.name = dto.name
        self.gender = dto.gender
        self.isNeutered = dto.isNeutered
        self.age = dto.age
        self.isAgeKnown = dto.isAgeKnown
        self.breed = dto.breed
        self.imageURL = dto.imageURL
        self.traits = dto.traits.map {
            PetTraitOption(category: $0.category, option: $0.option)
        }
        self.walkCount = dto.walkCount
    }
}
