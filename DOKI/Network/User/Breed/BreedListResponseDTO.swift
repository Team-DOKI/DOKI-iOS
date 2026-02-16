//
//  BreedListResponseDTO.swift
//  DOKI
//
//  Created by 이세민 on 2/16/26.
//

struct BreedListResponseDTO: Codable {
    let breedList: [BreedDTO]
}

struct BreedDTO: Codable, Identifiable {
    let id: Int
    let name: String
}
