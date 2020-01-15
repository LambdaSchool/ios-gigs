//
//  LoginViewController.swift
//  gigs
//
//  Created by Kenny on 1/15/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    enum LoginType: String {
        case signIn
        case signUp
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: IBActions
    @IBAction func loginMethodWasChanged(_ sender: UISegmentedControl) {
        print("changed")
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            loginType = .signUp
            print(loginType.rawValue)
        case 1:
            loginType = .signIn
            print(loginType.rawValue)
        default: fatalError("Only 2 segmented controls exist! Control #\(segmentedControl.selectedSegmentIndex) is out of range!")
        }
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        print(self.loginType)
        guard let usernameText = usernameTextField.text,
            usernameText != "",
            let passwordText = passwordTextField.text,
            passwordText != ""
        else {return}
        let user = User(username: usernameText, password: passwordText)
        if loginType == .signUp {
            gigController.signUp(with: user) { (error) in
                if let error = error {
                    print("Error signing up! \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.loginType = .signIn
                    self.segmentedControl.selectedSegmentIndex = 1
                    self.loginButton.setTitle("Sign In", for: .normal)
                }
                
            }
        } else {
            gigController.signIn(with: user) { (error) in
                if let error = error {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: Class Properties
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
