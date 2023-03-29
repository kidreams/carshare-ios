//
//  CSCarDetail.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit
import SwiftyJSON

struct CSCarDetail: CSModel {
    let carID: Int
    let makeAndModel: String
    let rentalPrice: Decimal
    let createdDate: Date
    
    let imagePath: String
    let lat: Double
    let long: Double
    
    var year: String?
    var colour: String?
    
    
    init?(json: JSON) {
        guard let carID: Int = json["id"].int,
              let makeAndModel: String = json["attributes"]["MakeAndModel"].string,
              let rentalPrice: Double = json["attributes"]["RentalPrice"].double,
              let createdDate: Date = json["attributes"]["createdAt"].date,
              let imagePath: String = json["attributes"]["photo"].string
        else { return nil }
        
        self.carID = carID
        self.makeAndModel = makeAndModel
        self.rentalPrice = Decimal(rentalPrice)
        
        self.createdDate = createdDate
        self.imagePath = imagePath
        self.colour = json["Colour"].string
        self.lat = json["attributes"]["lat"].doubleValue
        self.long = json["attributes"]["long"].doubleValue
        if let _year = json["attributes"]["Year"].int { self.year = String(_year) }
        
    }
}
