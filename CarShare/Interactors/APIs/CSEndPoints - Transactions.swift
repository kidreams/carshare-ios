//
//  CSEndPoints - Transactions.swift
//  CarShare
//
//  Created by nicholas on 3/27/23.
//

import Foundation
import Alamofire
extension CSEndPoints
{
    static func transactions() -> Self
    {
        let path = "/rental-transcations"
        return CSEndPoints(target: path,
                           header: [:])
    }
    
    static func createTransaction(transactionInfo: CSBody) -> Self
    {
        let path = "/rental-transcations"
        return CSEndPoints(target: path,
                           method: .post,
                           header: [:],
                           body: transactionInfo)
    }
    
    static func updateTransaction(transactionInfo: CSBody) -> Self
    {
        let path = "/rental-transcations"
        return CSEndPoints(target: path,
                           method: .put,
                           header: [:],
                           body: transactionInfo)
    }
}
