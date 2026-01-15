//
//  RegisterRequestDTO.swift
//  DOKI
//
//  Created by 권석기 on 7/15/25.
//

struct UserProfileDTO: Encodable {
    let loginId: String
    let password: String
    let name: String
    let gender: String
    let age: Int
    let regionId: Int
    let pet: PetProfileDTO
}

struct PetProfileDTO: Encodable {
    let name: String
    let gender: String
    let age: Int
    let isAgeKnown: Bool
    let isNeutered: Bool
    let breed: String
    let petTraits: [PetTraitsDTO]
}

struct PetTraitsDTO: Encodable {
    let traitCategoryId: Int
    let traitOptionId: Int
}
