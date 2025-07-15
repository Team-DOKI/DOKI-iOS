//
//  UserDataMapper.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

// UserProfile
extension UserProfile {
    func toDto() -> UserProfileDTO {
        UserProfileDTO(
            loginId: "dltnals",
            password: "12334",
            name: name,
            gender: gender,
            age: Int(age) ?? 0,
            regionId: Int(regionId) ?? 0,
            pet: PetProfileDTO(
                name: dogName,
                gender: gender,
                age: Int(age) ?? 0,
                isAgeKnown: isKnownAge,
                isNeutered: isNeutered,
                breed: breed,
                petTraits: [
                    .init(traitCategoryId: 0, traitOptionId: 1)                    
                ]
            )
        )
    }
}


