//
//  CSAuthenticator.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import UIKit

class CSAuthenticator: NSObject {
    static let manager: CSAuthenticator = {
        let instance = CSAuthenticator()
        /*
         Custom setup code
         */
        return instance
    }()
    
    @objc dynamic
    private var userToken: String?
    
    var token: String? { get { userToken } }
    
    var user: CSUser?
    
    private var authenticatorObservation: NSKeyValueObservation?
    
    internal let interactionFeedback = UINotificationFeedbackGenerator()
    
    var signedIn: Bool { get { isSignedIn() } }
    
    private
    var apiWorker: CSAPIWorker?
    
    private override init() {
        super.init()
        addObservations()
    }
    
    func SignUp() -> Void {
        //        SignOut()
    }
    
    func SignIn(with identifier: String,
                secret: String) -> Void {
        self.dismissWorker()
        let endPoint = CSEndPoints.signIn(with: identifier,
                                          secret: secret)
        let worker = CSAPIWorker(with: endPoint)?
            .prepare()
            .when(success: { [weak self] (json) in
                if let token = json["jwt"].string
                {
                    self?.update(token: token)
                }
                if let user = CSUser(json: json["user"])
                {
                    self?.update(user: user)
                }
                
                self?.dismissWorker()
            }).when(failure: { [weak self] (error) in
                self?.dismissWorker()
            }).fire()
        
        apiWorker = worker
    }
    
    func SignOut() -> Void {
        userToken = nil
    }
    
    func refreshUser() -> Void {
        self.dismissWorker()
        let endPoint = CSEndPoints.me()
        let worker = CSAPIWorker(with: endPoint)?
            .prepare()
            .when(success: { [weak self] (json) in
                if let token = json["jwt"].string
                {
                    self?.update(token: token)
                }
                if let user = CSUser(json: json)
                {
                    self?.update(user: user)
                }
                
                self?.dismissWorker()
            }).when(failure: { [weak self] (error) in
                self?.dismissWorker()
            }).fire()
        
        apiWorker = worker
    }
    
    private
    func dismissWorker() {
        self.apiWorker?.retire()
        self.apiWorker = nil
    }
    
    private
    func update(token: String) {
        guard !token.isEmpty else { return }
        self.userToken = token
    }
    
    private
    func update(user: CSUser) {
        self.user = user
    }
    
    private
    func isSignedIn() -> Bool {
//        return true // TODO: Debug only
        var authenticated: Bool = false
        if let _token = userToken {
            authenticated = _token.count > 0
        }
        print("Authentication: Is signed \(authenticated ? "In" : "Out")")
        return authenticated
    }
    
    private
    func addObservations() {
        authenticatorObservation = observe(\.userToken, options: [.new], changeHandler: { [weak self] object, changes in
            self?.broadcastAutnenticationStatus()
        })
    }
}
