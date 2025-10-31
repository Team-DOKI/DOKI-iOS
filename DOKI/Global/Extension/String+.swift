//
//  String+.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

extension String {
    func toFormattedDateString() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        guard let date = inputFormatter.date(from: self) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "yyyy/MM/dd"

        return outputFormatter.string(from: date)
    }
    
    func toFormattedDateTimeString() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        guard let date = inputFormatter.date(from: self) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "yyyy.MM.dd | HH:mm"

        return outputFormatter.string(from: date)
    }
}
