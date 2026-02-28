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
}
