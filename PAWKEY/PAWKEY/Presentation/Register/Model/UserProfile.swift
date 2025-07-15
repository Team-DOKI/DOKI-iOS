//
//  UserProfile.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import UIKit

struct UserProfile {
    var name: String = ""
    var gender: Gender = .male
    var age: String = ""
    var regionId: Int = 0
    var legalRegion: String = ""
    var dogName: String = ""
    var dogAge: String = ""
    var dogGender: Gender = .male
    var petTraits: [PetTraitCategory] = []
    var knownDogAge: KnownDogAge?
    var breed: String = ""
    var isNeutered = false
    var profileImage: UIImage?
    
    var isKnownAge: Bool {
        knownDogAge == .known
    }
}
