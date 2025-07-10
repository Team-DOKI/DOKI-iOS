//
//  Font+.swift
//  PAWKEY
//
//  Created by 권석기 on 7/7/25.
//

import SwiftUI

extension Font {
    static func pretendard(size: CGFloat, weight: Font.Weight) -> Font {
        let familyName = "Pretendard"
        
        var weightString: String
        switch weight {
        case .black:
            weightString = "Black"
        case .bold:
            weightString = "Bold"
        case .heavy:
            weightString = "ExtraBold"
        case .ultraLight:
            weightString = "ExtraLight"
        case .light:
            weightString = "Light"
        case .medium:
            weightString = "Medium"
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "SemiBold"
        case .thin:
            weightString = "Thin"
        default:
            weightString = "Regular"
        }
        
        return .custom("\(familyName)-\(weightString)", size: size)
    }
    
    static let head_24_b = Font.pretendard(size: 24, weight: .bold)
    static let head_22_b = Font.pretendard(size: 22, weight: .bold)
    static let head_22_sb = Font.pretendard(size: 22, weight: .semibold)
    static let head_20_b = Font.pretendard(size: 20, weight: .bold)
    static let head_20_sb = Font.pretendard(size: 20, weight: .semibold)
    static let head_18_sb = Font.pretendard(size: 18, weight: .semibold)
    static let body_16_sb = Font.pretendard(size: 16, weight: .semibold)
    static let body_16_m = Font.pretendard(size: 16, weight: .semibold)
    static let body_14_sb = Font.pretendard(size: 14, weight: .medium)
    static let body_14_m = Font.pretendard(size: 14, weight: .medium)
    static let body_14_r = Font.pretendard(size: 14, weight: .regular)
    static let caption_12_sb = Font.pretendard(size: 12, weight: .semibold)
    static let caption_12_m = Font.pretendard(size: 12, weight: .medium)
    static let caption_12_r = Font.pretendard(size: 12, weight: .regular)
}
