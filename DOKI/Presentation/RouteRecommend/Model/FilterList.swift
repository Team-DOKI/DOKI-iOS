//
//  FilterList.swift
//  DOKI
//
//  Created by 권석기 on 3/5/26.
//

import Foundation

// 필터 유형 적용을 위한 FilterType
enum FilterType {
    case duration
    case congestion
    case exchange
    case safety
    case convenience
    case environment
    case unknown
    
    // 서버에서 받아온 name을 기준으로 FilterType 반환 => 추후에 서버와 정해진 값을 논의해봐야 함
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

// 옵션을 포함하는 FilterData
struct FilterList {
    let id: Int
    let filterType: FilterType
    let selectionType: String
    var options: [FilteringOption]
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
