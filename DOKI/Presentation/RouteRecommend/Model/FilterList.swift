//
//  FilterList.swift
//  DOKI
//
//  Created by 권석기 on 3/5/26.
//

import Foundation

enum FilterType {
    case duration
    case congestion
    case exchange
    case safety
    case convenience
    case environment
    case unknown
    
    static func matchFilterType(_ string: String) -> Self {
        switch string {
        case "산책 소요 시간": .duration
        case "혼잡도": .congestion
        case "강아지 교류 빈도": .exchange
        case "안전": .safety
        case "편의성": .convenience
        case "환경": .environment
        default: .unknown
        }
    }
}

struct FilterList {
    let id: Int
    let filterType: FilterType
    let selectionType: String
    let options: [FilteringOption]
    let name: String
}

struct FilterTagItem: Identifiable {
    let id = UUID()
    let text: String
    let isActive: Bool
}

enum FilterCategory: String, CaseIterable {
    case walkTime
    case congestion
    case dogInteraction
    case safety
    case convenience
    case environment
    
    var title: String {
        switch self {
        case .walkTime: return "산책 소요 시간"
        case .congestion: return "혼잡도"
        case .dogInteraction: return "강아지 교류 빈도"
        case .safety: return "안전"
        case .convenience: return "편의성"
        case .environment: return "환경"
        }
    }
}
