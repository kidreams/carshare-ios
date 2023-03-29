//
//  AppDelegate - Firebase.swift
//  CarShare
//
//  Created by nicholas on 3/22/23.
//

import UIKit
import Firebase
import FirebaseMessaging

let FCMTokenDidReceiveNotification = Notification.Name("FCMTokenDidReceiveNotification")

extension AppDelegate: MessagingDelegate {
    internal
    func setupFirebaseMessaging(for application: UIApplication) {
        Messaging.messaging().delegate = self
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("AppDelegate: did receive FCM token -> \(fcmToken ?? "Empty")")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
          NotificationCenter.default.post(
            name: FCMTokenDidReceiveNotification,
            object: nil,
            userInfo: dataDict
          )
    }
}

