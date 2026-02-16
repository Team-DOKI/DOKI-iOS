//
//  RegisterRequestDTO.swift
//  DOKI
//
//  Created by 권석기 on 7/15/25.
//

struct UserProfileDTO: Encodable {
    let name: String
    let birth: String
    let gender: String
    let dongId: Int
    let pet: PetProfileDTO
}

struct PetProfileDTO: Encodable {
    let name: String
    let gender: String
    let birth: String
    let isNeutered: Bool
    let breedId: Int
    let imageId: Int
}
