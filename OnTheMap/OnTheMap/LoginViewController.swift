//
//  ViewController.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/5/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    func setUIEnabled(_ enabled: Bool) {
        userNameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    @IBAction func loginPressed(_ sender: Any) {
        setUIEnabled(false)
        loginUser()
    }
    
    private func loginUser() {
        
        //        let userName = userNameTextField.text
        //        let password = passwordTextField.text
        
        UdacityClient.sharedInstance().authenticateUser(userName: "aniket.ghode@gmail.com", password: "cue51&mint") { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                performUIUpdatesOnMain {
                    self.showError(errorString!)
                }
            }
            self.setUIEnabled(true)
        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

