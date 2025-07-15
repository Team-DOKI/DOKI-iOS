//
//  UserProfile.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

struct UserProfile {
    var name: String = ""
    var gender: String = ""
    var age: String = ""
    var region: String = ""
    
    var legalRegion: String = ""
    var dogName: String = ""
    var dogAge: String = ""
    var dogGender: String = ""
    var petTraits: [PetTraitCategory] = []
    var knownDogAge: KnownDogAge?
    var dogBreed: String = ""
    var isNeutered = false
    
    var isKnownAge: Bool {
        knownDogAge == .known
    }
}
