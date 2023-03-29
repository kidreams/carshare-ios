//
//  CSReservation.swift
//  CarShare
//
//  Created by nicholas on 3/24/23.
//

import UIKit
import SwiftyJSON
import Alamofire

struct CSReservation: CSModel {
    let reservationID: Int
    let title: String
    let resDescription: String
    let price: Decimal
    let currency: String
    let isSubscribtion: Bool
    let paypalOrderID: String
    let paypalLinks: [CSPaypalLink]
    let createdDate: Date
    let updatedDate: Date
    
    init?(json: JSON) {
        guard let id = json["id"].int,
              let title = json["title"].string,
              let desc = json["description"].string,
              let price = json["price"].double,
              let currency = json["currency"].string,
              ((json["paypalLinks"].null == nil) || !json["paypalLinks"].isEmpty),
              let isSubscribtion = json["isSubscription"].bool,
              let paypalOrderID = json["paypalOrderId"].string,
              let createdDate = json["createdAt"].date,
              let updatedDate = json["updatedAt"].date
        else { return nil }
        
        self.reservationID = id
        self.title = title
        self.resDescription = desc
        self.price = Decimal(price)
        self.currency = currency
        self.isSubscribtion = isSubscribtion
        self.paypalOrderID = paypalOrderID
        self.paypalLinks = json["paypalLinks"].csModelArray()
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
    

}


struct CSPaypalLink: CSModel {
    let link: String
    let rel: CSPaypalRel
    let method: HTTPMethod
    
    init?(json: JSON) {
        guard let link = json["href"].string,
              let rel =  json["rel"].string,
              let method = json["method"].string
        else { return nil }
        self.link = link
        self.rel = CSPaypalRel(rel)
        self.method = HTTPMethod(rawValue: method)
    }
    
}

enum CSPaypalRel: Int, RawRepresentable {
    
    public typealias RawValue = String
    case Unknown
    case `self`
    case approve
    case update
    case capture
    
    public var rawValue: RawValue { valueCheck() }
    
    
    public init(rawValue: RawValue) {
        self = Self.typeCheck(rawValue)
    }
    
    public init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
    
    private func valueCheck() -> String {
        
        switch self {
        case .`self`:          return "self"
        case .approve:         return "approve"
        case .update:      return "update"
        case .capture: return "capture"
        default:                return "unhandled"
        }
    }
    
    
    private static func typeCheck(_ value: String) -> Self {
        
        switch value {
        case "self":
            return .`self`
        case "approve":
            return .approve
        case "update":
            return .update
        case "capture":
            return .capture
        default:
            return .Unknown
        }
    }
}
    
