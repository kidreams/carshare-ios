//
//  CSTransaction.swift
//  CarShare
//
//  Created by nicholas on 3/28/23.
//

import UIKit
import SwiftyJSON
struct CSTransaction: CSModel {
    let transactionID: Int
    let transactionDate: Date
    let rentalStatus: Bool
    let rentalStartDate: Date
    let rentalEndDate: Date
    let totalRentalFee: Decimal
    
    init?(json: JSON) {
        guard let transID: Int = json["id"].int,
              let transactionDate: Date = json["attributes"]["RentalDate"].date,
              let rentalStatus: Bool = json["attributes"]["RentalStatus"].bool,
              let rentalStartDate: Date = json["attributes"]["RentalStartDate"].date,
              let rentalEndDate: Date = json["attributes"]["RentalDate"].date,
              let totalRentalFee: Double = json["attributes"]["TotalRentalFee"].double
        else { return nil }
        
        self.transactionID = transID
        self.transactionDate = transactionDate
        self.rentalStatus = rentalStatus
        self.rentalStartDate = rentalStartDate
        self.rentalEndDate = rentalEndDate
        self.totalRentalFee = Decimal(totalRentalFee)
    }
}
