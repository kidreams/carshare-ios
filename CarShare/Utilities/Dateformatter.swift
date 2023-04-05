//
//  Dateformatter.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit

let standardDateFormat      = "yyyy'-'MM'-'dd"
let mediumDateFormat        = "dd'-'MMM'-'yyyy"
let detailedDateTimeFormat  = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"

extension DateFormatter {
    
    convenience init(_ dateFormat: String,
//                     timeZone: String = "UTC") {
                     timeZone: TimeZone = TimeZone.current) {
        self.init()
        self.dateFormat = dateFormat
//        self.timeZone = TimeZone(abbreviation: timeZone)
        self.timeZone = timeZone
    }
    
    static let standard: DateFormatter = {
         return DateFormatter(standardDateFormat)
    }()
    
    static let medium: DateFormatter = {
        return DateFormatter(mediumDateFormat)
    }()
    
    static let extremeDetailed: DateFormatter = {
        return DateFormatter(detailedDateTimeFormat)
    }()
}
