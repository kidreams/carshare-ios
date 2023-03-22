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
                return DateFormatter.standard.date(from: value)
                
            }
        }
}

