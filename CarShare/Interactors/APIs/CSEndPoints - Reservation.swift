//
//  CSEndPoints - Reservation.swift
//  CarShare
//
//  Created by nicholas on 3/24/23.
//

import Foundation
import Alamofire
extension CSEndPoints
{
    static func createReservationWithPaymentRequest(orderInfo: CSBody) -> Self
    {
        let path = "/createProduct"
        return CSEndPoints(base: paymentRequestURL,
                           target: path,
                           method: .post,
                           header: [:],
                           body: orderInfo)
    }
}
