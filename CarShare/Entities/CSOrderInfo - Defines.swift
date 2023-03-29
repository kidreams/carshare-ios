//
//  CSOrderStatus - Defines.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import Foundation

enum CSOrderStatus: Int, RawRepresentable {
    typealias RawValue = String
    
    var rawValue: RawValue {
        switch self {
        case .unknown:
            return ""
        case .unpaid:
            return "unpaid"
        case .paid:
            return "paid"
        case .pending:
            return "pending"
        }
    }
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "paid":
            self = .paid
        case "unpaid":
            self = .unpaid
        case "pending":
            self = .pending
        default:
            self = .unknown
        }
    }
    
    init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
    
    case unknown
    case unpaid
    case pending
    case paid
}


enum CSPaymentMethod: Int, RawRepresentable {
    typealias RawValue = String
    
    var rawValue: RawValue {
        switch self {
        case .paypal: return "paypal"
        case .creditCard: return "credit_card"
        case .applePay: return "apple_pay"
        case .payme: return "payme"
        case .unknown: return ""
        }
    }
    
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "paypal": self = .paypal
        case "credit_card": self = .creditCard
        case "apple_pay": self = .applePay
        case "payme": self = .payme
        default: self = .unknown
        }
    }
    case unknown
    case paypal
    case creditCard
    case applePay
    case payme
}
