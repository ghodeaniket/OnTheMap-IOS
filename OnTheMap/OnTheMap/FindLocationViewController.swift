//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/12/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class FindLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveLocation(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
