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
    
    static let header1 = Font.pretendard(size: 28, weight: .bold)
    static let header2 = Font.pretendard(size: 24, weight: .bold)
    static let header3 = Font.pretendard(size: 20, weight: .bold)
    static let subtitle = Font.pretendard(size: 16, weight: .semibold)
    static let bodyDefault = Font.pretendard(size: 14, weight: .regular)
    static let bodyActive = Font.pretendard(size: 14, weight: .regular)
    static let bodySmall = Font.pretendard(size: 12, weight: .medium)
    static let mainDefault = Font.pretendard(size: 18, weight: .regular)
    static let subDefault = Font.pretendard(size: 12, weight: .regular)
    static let subActive = Font.pretendard(size: 12, weight: .semibold)
    static let small = Font.pretendard(size: 10, weight: .semibold)
    static let link = Font.pretendard(size: 12, weight: .regular)
}
