//
//  CSOrderInfo.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import UIKit
import SwiftyJSON

// Top Level
class CSOrderInfo: NSObject, CSModel {
    
    var orderID: Int
    var amount: NSDecimalNumber?
    
    var dueDate: Date
    var billingDate: Date
    var fuelCostAdjust: Double
    var monthlyMaintenanceCharge: Double
    var standardGasCharge: Double
    
    var billStartDate: Date
    var billEndDate: Date
    
    var otherCharges: [CSAdditionalCharge]
    
    var billStatus: CSBillStatus
    
    var paymentReceiveDate: Date?
    var paymentReceived: Double
    
    required init?(json: JSON) {
        guard let billID: Int       = json["id"].int,
              let dueDate           = json["due_date"].date,
              let billingDate       = json["billing_date"].date,
              let estimatedUsage    = json["estimated_usage"].int,
              let fuelCostAdjust    = json["fuel_cost_adjust"].double,
              let monthlyMainCharge = json["monthly_main_charge"].double,
              let standardGasCharge = json["standard_gas_charge"].double,
              let billStartDate     = json["bill_start_date"].date,
              let billEndDate       = json["bill_end_date"].date
        else { return nil }
        
        self.orderID                     = orderID
        self.dueDate                    = dueDate
        self.orderingDate                = orderingDate
        self.estimatedUsage             = estimatedUsage
        self.clientReportedUsage        = json["client_reported_usage"].int
        self.fuelCostAdjust             = fuelCostAdjust
        self.monthlyMaintenanceCharge   = monthlyMainCharge
        self.standardGasCharge          = standardGasCharge
        self.billStatus                 = TGBillStatus(rawValue: json["bill_status"].stringValue)
        
        self.billStartDate              = billStartDate
        self.billEndDate                = billEndDate
        self.paymentReceiveDate         = json["payment_receive_date"].date
        self.paymentReceived            = json["payment_receive"].doubleValue
        self.otherCharges               = json["additional_charge_items"].tgModelArray()
        
        super.init()
    }
}

class CSAdditionalCharge: NSObject, CSModel {
    var itemName: String
    var amount: Double
    
    required init?(json: JSON) {
        guard let name = json["charge_name"].string,
              let value = json["amount"].double else { return nil }
        self.itemName = name
        self.amount = value
    }
}
