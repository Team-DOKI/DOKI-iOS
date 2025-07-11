//
//  ChangeMyAreaViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI

struct UserAreaProfile {
    var region: String = ""
    var legalRegion: String = ""
}

enum AreaProfileField {
    case region(String)
    case legalRegion(String)
}

final class ChangeActivityAreaViewModel: ObservableObject {
    @Published var userProfile = UserAreaProfile()
    
    let regionList = ["강남구"]
    let legalRegionList = [
        "개포동", "논현동", "대치동", "도곡동", "삼성동",
        "세곡동", "수서동", "신사동", "압구정동", "역삼동",
        "율현동", "자곡동", "청담동", "일원동"
    ]
    
    func changeUserInfo(_ field: AreaProfileField) {
        switch field {
        case .region(let region):
            userProfile.region = region
            userProfile.legalRegion = ""
        case .legalRegion(let legalRegion):
            userProfile.legalRegion = legalRegion
        }
    }
}
