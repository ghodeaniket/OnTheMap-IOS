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

        // create and set the logout button
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
    }

    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
