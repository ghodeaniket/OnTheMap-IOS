//
//  PostInformationViewController.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/11/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class PostInformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(false, animated: true)

    }
    
    @IBAction func findLocationOnMap(_ sender: Any) {
        performSegue(withIdentifier: "findLocation", sender: self)
    }    
}
