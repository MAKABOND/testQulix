//
//  String.swift
//  TestNewsApp
//
//  Created by пользователь on 4/3/21.
//

import Foundation

// MARK: - Setting date format 
extension String {
    func converterStringToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
}
