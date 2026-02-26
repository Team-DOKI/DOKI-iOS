//
//  BirthDateInputFormatter.swift
//  DOKI
//
//  Created by 이세민 on 2/27/26.
//

import Foundation

enum BirthDateInputFormatter {
    static func autoFormat(_ input: String) -> String {
        let numbersOnly = input.filter { $0.isNumber }
        let limited = String(numbersOnly.prefix(8))
        
        let count = limited.count
        
        switch count {
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
