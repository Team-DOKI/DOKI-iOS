//
//  BreedListResponse.swift
//  DOKI
//
//  Created by 이세민 on 2/16/26.
//

struct BreedListResponse: Codable {
    let breedList: [BreedList]
}

struct BreedList: Codable, Identifiable {
    let id: Int
    let name: String
}
