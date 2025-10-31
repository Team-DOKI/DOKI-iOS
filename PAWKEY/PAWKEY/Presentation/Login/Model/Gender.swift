//
//  Gender.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

enum Gender: String, CaseIterable, Identifiable {
    case male = "남성"
    case female = "여성"
    
    var id: String { rawValue }
    
    var dogText: String {
        switch self {
        case .male:
            "남아"
        case .female:
            "여아"
        }
    }
}
