//
//  Date - Utilities.swift
//  CarShare
//
//  Created by nicholas on 3/28/23.
//

import Foundation

extension Date {
    func days(between date: Date) -> Int? {
        var startDate = self
        var endDate = date
        
        if startDate > endDate {
            startDate = endDate
            endDate = self
        }
        let componments = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        return componments.day
    }
}
