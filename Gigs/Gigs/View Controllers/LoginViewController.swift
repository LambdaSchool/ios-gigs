//
//  ViewController.swift
//  Gigs
//
//  Created by morse on 10/30/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    enum LoginType {
        case logIn, signUp
    }
    
    var gigController: GigController?
    var loginType: LoginType = .signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        
    }
    
    @IBAction func SignInTypeChanged(_ sender: Any) {
        switch loginType {
        case .signUp:
            loginType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        case .logIn:
            loginType = .logIn
            loginButton.setTitle("Sign In", for: .normal)
        }
    }
    

}

