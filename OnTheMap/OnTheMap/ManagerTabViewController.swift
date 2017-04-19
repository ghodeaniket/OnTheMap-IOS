//
//  ManagerTabViewController.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/12/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class ManagerTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Logout
    
    @IBAction func addStudentLocation(_ sender: Any) {
        if UdacityClient.sharedInstance().hasAddedLocation {
            let alert: UIAlertController = UIAlertController(title: "", message: "You have already posted your location. Would you like to overwrite?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "AddStudentLocation", sender: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "AddStudentLocation", sender: nil)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        ActivityIndicator.sharedInstance().startActivityIndicator(self)
        UdacityClient.sharedInstance().logoutUserSession { (success, errorString) in
            performUIUpdatesOnMain {
                ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showError(errorString ?? "Unknown error")
                }
            }
            
        }
    }
    
    private func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "On The Map", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
