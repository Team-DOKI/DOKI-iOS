//
//  Pet.swift
//  DOKI
//
//  Created by a on 1/12/26.
//

struct Pet: Codable {
    let petId: Int
    let imageUrl: String
    let name: String
    let birth: String
    let age: Int
    let gender: String
    let isNeutered: Bool
    let breed: String
    let dbti: String?

    var displayDbti: String {
        dbti ?? "DBTI 검사 미완료"
    }
}
