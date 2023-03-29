//
//  CSEndPoints - Payment.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import Foundation
import Alamofire

extension CSEndPoints
{
    static func createPayment( body: CSBody) -> Self
    {
        let path = "/payment-transactions"
        return CSEndPoints(target: path,
                           method: .post,
                           header: [:],
                           body: body)
    }
}
