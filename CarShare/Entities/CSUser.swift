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
    var phoneNumber: String // D
    var email: String // D
    
    var nameInEng: String? // D
    var namePrefix: String? // D
    
    
    var licenseID: String?
    
    
//    var orders: [CSOrderInfo]
    
    required init?(json: JSON) {
        guard
            let userID: Int         = json["id"].int,
            let userName: String    = json["username"].string,
            let email: String       = json["email"].string,
            let phoneNumber: String = json["phone_number"].string,
            let accountNo: String = json["account_number"].string
        
        else
        { return nil }
        
        self.accountNumber  = accountNo
        
        self.userID         = userID
        
        self.userName       = userName
        self.email          = email
        self.phoneNumber    = phoneNumber
        
        
        self.nameInEng      = json["name_eng"].string
        self.namePrefix     = json["name_prefix"].string
        
//        self.orders          = json["orders"].csModelArray().sorted(by: { $0.orderingDate > $1.orderingDate })
        super.init()
    }
}
