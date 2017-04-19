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
    
    var keyboardOnScreen = false
    
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
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }

    @IBAction func loginPressed(_ sender: Any) {
     
        loginUser()
    }
    
    private func loginUser() {
        
        if userNameTextField.text!.isEmpty {
            showError("Username can't be empty")
            return
        }
        if passwordTextField.text!.isEmpty {
            showError("Password can't be empty")
            return
        }
        setUIEnabled(false)
        ActivityIndicator.sharedInstance().startActivityIndicator(self)
        UdacityClient.sharedInstance().authenticateUser(userName: userNameTextField.text!, password: passwordTextField.text!) { (success, errorString) in
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                if success {
                    self.completeLogin()
                } else {
                    self.passwordTextField.text = ""
                    self.showError(errorString!)
                }
            }
        }
    }
    
    private func completeLogin() {
        self.setUIEnabled(true)
        userNameTextField.text = ""
        passwordTextField.text = ""
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
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

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            // Move View just enough to show the login button
            view.frame.origin.y -= loginButton.frame.origin.y + 20.0
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

