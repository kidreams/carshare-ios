//
//  CSEndPoints - Cars.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import Foundation
import Alamofire
extension CSEndPoints
{
    static func cars() -> Self
    {
        let path = "/cars"
        return CSEndPoints(target: path,
                           header: [:])
    }
    
    static func update(car: CSBody, with carID: String) -> Self
    {
        let path = "/cars/\(carID)"
        return CSEndPoints(target: path,
                           method: .put,
                           header: [:],
                           body: car)
    }
}
