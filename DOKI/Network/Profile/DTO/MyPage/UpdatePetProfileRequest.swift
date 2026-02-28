//
//  UpdatePetProfileRequest.swift
//  DOKI
//
//  Created by 이세민 on 2/27/26.
//

struct UpdatePetProfileRequest: Codable {
    let name: String?
    let birth: String?
    let gender: String?
    let isNeutered: Bool?
    let breedId: Int?
    let imageId: Int?
}
