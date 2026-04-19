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
    
    func formattedToYYMMDD(_ format: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        guard let date = formatter.date(from: self) else { return self }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = format
        return displayFormatter.string(from: date)
    }
    
    func formattedToYYMMDD() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        guard let date = formatter.date(from: self) else { return self }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yy.MM.dd"
        return displayFormatter.string(from: date)
    }
    
    /// 마지막 글자 받침 여부에 따라 "와" 또는 "과" 반환
    var josaWaGwa: String {
        guard let last = self.last,
              let scalar = last.unicodeScalars.first else { return "와" }
        let code = scalar.value
        guard code >= 0xAC00, code <= 0xD7A3 else { return "와" }
        return (code - 0xAC00) % 28 == 0 ? "와" : "과"
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
