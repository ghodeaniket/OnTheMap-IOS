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
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postStudentInformation(_ sender: Any) {
        performSegue(withIdentifier: "ShowInformationPostingView", sender: self)
    }
}
