//
//  PetProfileResponseDTO.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

struct PetProfileResponseDTO: Codable {
    let petId: Int
    let imageUrl: String
    let name: String
    let birth: String
    let age: String
    let gender: String
    let isNeutered: Bool
    let breed: String
    let dbtiName: String?
    let dbtiDescription: String?
}
