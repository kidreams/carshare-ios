//
//  CSOrderDetail.swift
//  CarShare
//
//  Created by nicholas on 3/25/23.
//

import UIKit
import SwiftyJSON
struct CSOrderDetail: CSModel {
    let carID: Int
    let title: String
    let rentalDate: Date
    let rentalStatus: Bool
    let rentalStartDate: Date
    let rentalEndDate: Date
    let totalRentalFee: Decimal
    
    init?(json: JSON) {
        guard let carID: Int = json["id"].int,
              let rentalDate: Date = json["attributes"]["RentalDate"].date,
              let rentalStatus: Bool = json["attributes"]["RentalStatus"].bool,
              let rentalStartDate: Date = json["attributes"]["RentalStartDate"].date,
              let rentalEndDate: Date = json["attributes"]["RentalDate"].date,
              let totalRentalFee: Double = json["attributes"]["TotalRentalFee"].double
        else { return nil }
        
        self.carID = carID
        self.title = json["attributes"]["title"].stringValue
        self.rentalDate = rentalDate
        self.rentalStatus = rentalStatus
        self.rentalStartDate = rentalStartDate
        self.rentalEndDate = rentalEndDate
        self.totalRentalFee = Decimal(totalRentalFee)
    }
}
