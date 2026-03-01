//
//  String+.swift
//  DOKI
//
//  Created by 이세민 on 2/28/26.
//

import Foundation

extension String {
    func formattedBirthDate() -> String {
        let numbersOnly = self.filter { $0.isNumber }
        let limited = String(numbersOnly.prefix(8))
        
        switch limited.count {
        case 0...3:
            return limited
        case 4:
            return limited + "/"
        case 5:
            let year = limited.prefix(4)
            let month = limited.suffix(1)
            return "\(year)/\(month)"
        case 6:
            let year = limited.prefix(4)
            let month = limited.dropFirst(4)
            return "\(year)/\(month)/"
        default:
            let year = limited.prefix(4)
            let month = limited.dropFirst(4).prefix(2)
            let day = limited.dropFirst(6)
            return "\(year)/\(month)/\(day)"
        }
    }
    
    func formattedToYYMMDD() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        guard let date = formatter.date(from: self) else { return self }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy/MM/dd"
        return displayFormatter.string(from: date)
    }
    
    func formattedCategoryTag() -> String {
        switch self {
        case "적음", "평범", "많음":
            return "혼잡도 \(self)"
        case "보통":
            return "교류 \(self)"
        default:
            return self
        }
    }
}

extension Int {
    func formattedDuration() -> String {
        if self <= 60 {
            return "\(self)min"
        } else {
            let hours = self / 60
            let minutes = self % 60
            if minutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(minutes)min"
            }
        }
    }
}
