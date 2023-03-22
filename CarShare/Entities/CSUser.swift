//
//  CSUser.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import UIKit
import SwiftyJSON

class CSUser: NSObject, CSModel {
    var accountNumber: String // D
    
    var userID: Int
    
    var userName: String // D
    var telNumber: String // D
    var email: String // D
    
    var nameInEng: String? // D
    var namePrefix: String? // D
    
    
    var licenseID: String?
    
    
    var orders: [CSOrderInfo]
    
    required init?(json: JSON) {
        guard
            let userID: Int         = json["id"].int,
            let userName: String    = json["username"].string,
            let email: String       = json["email"].string,
            let telNumber: String   = json["tel_number"].string,
            let contactName: String = json["contact_name"].string,
            let contactNo: String   = json["contact_number"].string,
            
            let accountNo: String = json["account_number"].string
        
        else
        { return nil }
        
        self.accountNumber  = accountNo
        self.bankAutoPay    = json["bank_autopay"].boolValue
        
        self.userID         = userID
        
        self.userName       = userName
        self.telNumber      = telNumber
        self.email          = email
        
        self.contactName    = contactName
        self.contactNumber  = contactNo
        
        self.nameInEng      = json["name_eng"].string
        self.namePrefix     = json["name_prefix"].string
        self.ebill_email    = json["ebill_email"].string
        
        self.gasAddress     = json["gas_supply_address"].string
        
        self.bills          = json["bills"].tgModelArray().sorted(by: { $0.billingDate > $1.billingDate })
        super.init()
    }
}
