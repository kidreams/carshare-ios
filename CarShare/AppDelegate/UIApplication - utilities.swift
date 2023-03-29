//
//  UIApplication - utilities.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        // TODO: when viewDidAppear has not been triggered,
        // Get connected scenes
        let keyWindow = UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
     return keyWindow
    }
}
