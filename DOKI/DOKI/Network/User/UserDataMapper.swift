////
////  UserDataMapper.swift
////  PAWKEY
////
////  Created by 권석기 on 7/15/25.
////
//
//// UserProfile
//
//import Foundation
//
//extension UserProfile {
//    func toDto() -> UserProfileDTO {
//        UserProfileDTO(
//            loginId: "dltnals",
//            password: "123342343434324",
//            name: name,
//            gender: gender.rawValue,
//            age: Int(age) ?? 0,
//            regionId: regionId,
//            pet: PetProfileDTO(
//                name: dogName,
//                gender: gender.rawValue,
//                age: Int(age) ?? 0,
//                isAgeKnown: isKnownAge,
//                isNeutered: isNeutered,
//                breed: breed,
//                petTraits: petTraits.map {
//                    PetTraitsDTO(traitCategoryId: $0.categoryId, traitOptionId: $0.categoryOptions.first(where: { $0.isSelected})?.categoryOptionId ?? 0)  
//                }
//            )
//        )
//    }
//}
//
//
