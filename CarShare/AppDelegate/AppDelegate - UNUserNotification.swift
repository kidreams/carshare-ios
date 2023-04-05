//
//  AppDelegate - UNUserNotification.swift
//  CarShare
//
//  Created by nicholas on 3/22/23.
//

import UIKit
import Firebase
import FirebaseMessaging

extension AppDelegate {
    internal
    func registerUserNotification(for application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    // MARK: - Application Event for Remote Notifications
    
    // MARK: - Notification Registrations
    // MARK: Success
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /*
         Reference: https://nshipster.com/apns-device-tokens/
         Recommended:
         %02.2hhx -> (%02x | %.2x)
         
         But any difference in behavior is moot, so long as Data is a collection whose Element is UInt8:
         (UInt.min...UInt.max).map {
         String(format: "%02.2hhx", $0) == String(format: "%02x", $0)
         }.contains(false) // false
         */
//        Messaging.messaging().apnsToken = deviceToken
        let tokenString = deviceToken.map({ String(format: "%02x", $0) }).joined()
        print("AppDelegate: register APNs success with token -> \(tokenString)")
    }
    
    // MARK: Failure
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("AppDelegate: register APNs failure with error -> \(error)")
    }
    
    // MARK: - Received Notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //          if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //          }
        
        // Print full message.
        print("AppDelegate: did receive notification body -> \(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: - UserNotificationCenter Delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // ...
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print("AppDelegate: did receive notification response body -> \(userInfo)")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // ...
        
        // Print full message.
        print("AppDelegate: will present notification body -> \(userInfo)")
        // Change this to your preferred presentation option
        completionHandler([[.badge, .list, .banner, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}

