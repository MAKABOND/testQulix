//
//  Date+TastNewsApp.swift
//  TestNewsApp
//
//  Created by пользователь on 4/3/21.
//

import Foundation

// MARK: - Days counter extension
extension Date {
    
    var startOfDay: Date {
        return Calendar(identifier: .gregorian).startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfDay)!
    }
    
    func convertDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: self)
    }
}
