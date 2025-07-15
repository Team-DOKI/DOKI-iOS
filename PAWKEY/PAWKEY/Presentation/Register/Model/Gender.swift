//
//  Gender.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

enum Gender: String, CaseIterable {
    case unknown = ""
    case male = "M"
    case female = "F"
    
    var userGenderText: String {
        switch self {
        case .male:
            return "남자"
        case .female:
            return "여자"
        default:
            return ""
        }
    }
    
    var petGenderText: String {
        switch self {
        case .male:
            return "남아"
        case .female:
            return "여아"
        default:
            return ""
        }
    }
}
