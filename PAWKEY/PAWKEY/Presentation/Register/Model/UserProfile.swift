//
//  UserProfile.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import UIKit

struct UserProfile {
    var name: String = ""
    var age: String = ""
    var regionId: Int = 0
    var legalRegion: String = ""
    var dogName: String = ""
    var dogAge: String = ""
    var petTraits: [PetTraitCategory] = []
    var knownDogAge: KnownDogAge?
    var gender: Gender = .unknown
    var dogGender: Gender = .unknown
    var breed: String = ""
    var isNeutered = false
    var profileImage: UIImage?
    
    var isKnownAge: Bool {
        knownDogAge == .known
    }
}
