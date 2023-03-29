//
//  CSEndPoints - User.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import Foundation
import UIKit
import Alamofire

extension CSEndPoints
{
    static func signIn(with identifier: String,
                     secret: String) -> Self
    {
        let path = "/auth/local"
        let body = ["identifier": identifier,
                    "password": secret]
        return CSEndPoints(target: path,
                           method: .post,
                           body: body)
    }
    
    static func signUp(with userInfo: [AnyHashable: String]) -> Self
    {
        let path = "/user"
        return CSEndPoints(target: path,
                           method: .post,
                           encoding: JSONEncoding.default,
                           body: userInfo)
    }
    
    /// Get user info
    /// - Returns: <#description#>
    static func users() -> Self
    {
        let path = "/users"
        return CSEndPoints(target: path,
                           encoding: JSONEncoding.default)
    }

    
    /// Get user info
    /// - Returns: <#description#>
    static func me() -> Self
    {
        let path = "/users/me"
        return CSEndPoints(target: path,
                           encoding: JSONEncoding.default)
    }
    
    
    /// Update user info
    /// - Parameter userInfo: user data to be updated
    /// - Returns: <#description#>
    static func update(userInfo: [AnyHashable: String]) -> Self
    {
        let path = "/users/me"
        return CSEndPoints(target: path,
                           method: .patch,
                           encoding: JSONEncoding.default,
                           body: userInfo)
    }
}
