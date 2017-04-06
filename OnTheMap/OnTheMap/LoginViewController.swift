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
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    @IBAction func loginPressed(_ sender: Any) {
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
            
            func displayError(_ error: String) {
                print(error)
                
                performUIUpdatesOnMain {
//                    self.debugTextLabel.text = "Login Failed (Request Token)"
//                    self.setUIEnabled(true)
                }
            }
            
            guard (error == nil) else {
                print(error)
//                displayError(error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                displayError("Request returned status code other than 2XX")
                return
            }
            
            
            
            guard let data = data else {
                displayError("No data returned")
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
            
            print(parsedResult)
            

        }
        
        task.resume()
    }
}

