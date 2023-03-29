//
//  SignInUpViewController.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit
import TextFieldEffects
import IQKeyboardManagerSwift

class SignInUpViewController: BaseViewController {

    @IBOutlet weak var textFieldStack: UIStackView!
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupKeyBoardManager()
        
        self.userNameField.text = "user"
        self.passwordField.text = "AZsxdc@123"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupKeyBoardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIView.self, UIStackView.self]
    }
    
    @IBAction func SignInAction(_ sender: Any) {
        guard let identifier = self.userNameField.text, !identifier.isEmpty,
              let secret = self.passwordField.text, !secret.isEmpty
        else
        {
            return
        }
        CSAuthenticator.manager.SignIn(with: identifier, secret: secret)
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        CSAuthenticator.manager.SignUp()
    }
}
