//
//  ViewController.swift
//  OnTheMap
//
//  Created by vikas on 15/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let loginSuccessSegueID = "loginSuccess"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enableUIControllers(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        enableUIControllers(false)
        NetworkManager.login(username: emailTextField.text!,password: passwordTextField.text!) {
                        (errorMessage) in
                if let errorMessage = errorMessage {
                self.enableUIControllers(true)
            DataTaskController.showSimpleAlert(viewController: self,title: "Failed to Login", message: errorMessage)
        }
        else {
                self.performSegue(withIdentifier: self.loginSuccessSegueID, sender: self)
            }
        }
    }
    
    
    @IBAction func signupButtonTapped(_ sender: Any){
        let url = URL(string: "https://auth.udacity.com/sign-up")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func enableUIControllers(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = enabled
            self.passwordTextField.isEnabled = enabled
            self.loginButton.isEnabled = enabled
            self.signupButton.isEnabled = enabled
            enabled ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        }
    }
    
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
