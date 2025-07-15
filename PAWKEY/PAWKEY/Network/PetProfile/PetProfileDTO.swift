//
//  PetProfileDTO.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/15/25.
//

import Foundation

struct PetProfileDTO: Codable {
    let code, message: String
    let petProfileList: [PetProfileDetailDTO]
    
    enum CodingKeys: String, CodingKey {
            case code, message
            case petProfileList = "data" 
        }
}

struct PetProfileDetailDTO: Codable {
    let petID: Int
    let name, gender: String
    let isNeutered: Bool
    let age: Int
    let isAgeKnown: Bool
    let breed, imageURL: String
    let traits: [PetProfileTrait]
    let walkCount: Int

    enum CodingKeys: String, CodingKey {
        case petID = "petId"
        case name, gender, isNeutered, age, isAgeKnown, breed
        case imageURL = "imageUrl"
        case traits, walkCount
    }
}

struct PetProfileTrait: Codable {
    let category, option: String
}

