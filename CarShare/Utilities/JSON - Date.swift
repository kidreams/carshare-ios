//
//  JSON - Date.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import SwiftyJSON

extension JSON {
    
    public var date: Date? {
            get {
                guard type == .string,
                      let value: String = self.object as? String else { return nil }
                var newDate: Date?
                if let _date: Date = DateFormatter.standard.date(from: value) {
                    newDate = _date
                } else if let _date: Date = DateFormatter.medium.date(from: value) {
                    newDate = _date
                } else if let _date: Date = DateFormatter.extremeDetailed.date(from: value) {
                    newDate = _date
                }
                return newDate
            }
        }
}

