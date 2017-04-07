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
        
        let userName = userNameTextField.text
        let password = passwordTextField.text
        
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: appDelegate.udacityURLFromParameters(withPathExtension: "/session"))
        /* 2/3. Build the URL, Configure the request */
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"aniket.ghode@gmail.com\", \"password\": \"cue51&mint\"}}".data(using: String.Encoding.utf8)
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func displayError(_ errorMessage: String) {
                print(errorMessage)
                
                performUIUpdatesOnMain {
                    self.showError(errorMessage)
                    self.setUIEnabled(true)
                }
            }
            
            guard (error == nil) else {
                print("Error while logging in user \(error)")
                displayError("There was an error connecting to Udacity API")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                guard statusCode >= 200 && statusCode <= 299 else{
                    if statusCode == 403 {
                        print("Error while logging in user, (Invalid Credentials.")
                        displayError("Account doesn't exist or invalid credentials. Please try again.")
                    } else {
                        print("Error while logging in user, (Unknown Error.")
                        displayError("Couldn't login, Please try again.")
                    }
                    return
                }
            } else {
                print("Error while logging in user, (Unknown Error.")
                displayError("Couldn't login, Please try again.")
            }
            
            guard let data = data else {
                print("Error while logging in user, (No Data returned).")
                displayError("Couldn't login, Please try again.")
                return
            }
            
            let range = Range(5 ..< data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            var parsedResult : [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
            }catch {
                displayError("Could not parse data \(data)")
                return
            }
            
            guard let accountInfo = parsedResult[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject]? else {
                print("Login failed. No Account information.")
                displayError("Couldn't login, Please try again.")
                return
            }
            
            guard let userKey = accountInfo![UdacityClient.JSONResponseKeys.Key] as? String? else {
                print("Coundn't find key '\(UdacityClient.JSONResponseKeys.Key)' in '\(parsedResult)'")
                displayError("Couldn't login, Please try again.")
                return
            }
            
            self.appDelegate.accountID = userKey
            
            guard let sessionInfo = parsedResult[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject]?, let sessionID = sessionInfo![UdacityClient.JSONResponseKeys.sessionID] as? String? else {
                print("Coundn't find key '\(UdacityClient.JSONResponseKeys.sessionID)' in '\(parsedResult)'")
                displayError("Couldn't login, Please try again.")
                return
            }
            
            self.appDelegate.sessionID = sessionID
            self.completeLogin()
            print(parsedResult)
        }
        
        task.resume()
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "StudentLocationsMapViewController") as! UITabBarController
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

