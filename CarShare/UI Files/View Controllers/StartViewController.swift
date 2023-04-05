//
//  StartViewController.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupInitialUIs()
        addNotificationObservers()
//        fatalError("This is a firebase crash simulation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        processToMainPage()
//        return
        if CSAuthenticator.manager.signedIn {
            processToMainPage()
        } else {
            processToAuthenticationPage()
        }
    }
    
    func setupInitialUIs() {
        
        let startImage = UIImage(named: "launch-screen-logo")
        let imageView = UIImageView(image: startImage)
        imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(imageView)
        
        // Add constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let centerY = imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let centerX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let leading = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        let trailing = imageView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10)
        var multiplier: CGFloat = 1/1
        if let size = startImage?.size {
            multiplier = size.height/size.width
        }
        let aspectRatio = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: multiplier)
        let constraints =
            [
                centerX,
                centerY,
                leading,
                trailing,
                aspectRatio
            ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func processToMainPage() {
        
        if let currentVC = self.presentedViewController
        {
            if currentVC is BaseNavigationViewController,
               (currentVC as? BaseNavigationViewController)?.viewControllers.first is CSTabBarViewController
            { return }
            else
            { currentVC.dismiss(animated: true, completion: nil) }
        }
        let storyboard                  = UIStoryboard(name: "Main", bundle: nil)
        let navigationViewController: BaseNavigationViewController = storyboard.instantiateViewController(identifier: "RootNavigationViewController") as! BaseNavigationViewController
        
        navigationViewController.modalPresentationStyle = .fullScreen
        
        self.present(navigationViewController, animated: true, completion: nil)
        
    }
    
    func processToAuthenticationPage() {
        
        if let currentVC = self.presentedViewController
        {
            if currentVC is SignInUpNavigationViewController
            { return }
            else
            { currentVC.dismiss(animated: true, completion: nil) }
        }
        
        let storyboard                  = UIStoryboard(name: "Authentication", bundle: nil)
        let navigationViewController    = storyboard.instantiateInitialViewController() as! SignInUpNavigationViewController
        navigationViewController.isModalInPresentation = true
        
        self.present(navigationViewController, animated: true, completion: nil)
        
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceived(notification:)), name: UserSignedInNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceived(notification:)), name: UserSignedOutNotification, object: nil)
    }
    
    
    @objc
    func didReceived(notification: Notification) {
        switch notification.name {
        case UserSignedInNotification:
            processToMainPage()
        case UserSignedOutNotification:
            processToAuthenticationPage()
        default:
            break
        }
    }


}

