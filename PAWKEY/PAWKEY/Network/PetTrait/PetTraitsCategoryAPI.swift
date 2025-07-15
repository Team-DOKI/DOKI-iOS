//
//  PetTraitsCategoryAPI.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

import Moya

enum PetTraitsCategoryAPI {
    case fetchPetTraitsCategories
}

extension PetTraitsCategoryAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchPetTraitsCategories:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchPetTraitsCategories:
            return "pets/traits/categories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPetTraitsCategories:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchPetTraitsCategories:
            return .requestPlain
        }
    }
}
