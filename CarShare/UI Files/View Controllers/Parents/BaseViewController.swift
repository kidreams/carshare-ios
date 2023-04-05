//
//  BaseViewController.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit

class BaseViewController: UIViewController {
    var apiWorker: CSAPIWorker?
    var apiWorkers: [CSAPIWorker] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("Initializing \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "theme-color-dark")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = self.title?.uppercased()
    }
    
    internal
    func dismissWorker() {
        self.apiWorker?.retire()
        self.apiWorker = nil
    }
    internal
    func add(worker: CSAPIWorker) {
        apiWorkers.append(worker)
    }
    
    internal
    func dismissWorkers() {
        apiWorkers.forEach({$0.retire()})
        apiWorkers = []
    }
    
    deinit {
        self.dismissWorker()
        print("Deinitializing \(self)")
    }
}

extension UIViewController {
    func show(title: String? = nil,
              message: String?,
              completion: (()->(Void))? = nil) {
        if title == nil && message == nil { return }
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.warning)
        let title = title ?? ""
        let message = message ?? ""
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancelTitle = "Dismiss"
        
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            completion?()
        }
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    func updateKeyWindow(rootViewController: UIViewController?) {
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        keyWindow?.rootViewController = rootViewController
    }
}
