//
//  Authenticator - Helpers.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import Foundation

let UserSignedInNotification = Notification.Name(rawValue: "UserSignedInNotification")
let UserSignedOutNotification = Notification.Name(rawValue: "UserSignedOutNotification")

extension CSAuthenticator {
    internal func broadcastAutnenticationStatus() {
        var notification = Notification.Name("")
        if signedIn
        { notification = UserSignedInNotification }
        else
        { notification = UserSignedOutNotification }
        
        NotificationCenter.default.post(name: notification, object: nil)
        interactionFeedback.notificationOccurred(.success)
        print("Authentication: notification posted -> \(notification.rawValue)")
    }
}
