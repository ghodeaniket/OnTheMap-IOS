//
//  PostInformationViewController.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/11/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import MapKit

class PostInformationViewController: UIViewController {

    var location: String?
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func findLocationOnMap(_ sender: Any) {
        guard let searchString = locationTextField.text else {
            print("Empty string for location")
            displayError("Please enter location")
            return
        }
        
        getLocationData(fromSearchString: searchString) { (success, placeMark, errorString) in
            if (success) {
                self.performSegue(withIdentifier: "findLocation", sender: self)
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    private func getLocationData(fromSearchString searchString: String, completionHandlerForLocationData: @escaping (_ success: Bool, _ locationData: CLPlacemark?, _ errorString: String?) -> Void ){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchString, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemark = placemarks?[0] {
                completionHandlerForLocationData(true, placemark, nil)
            } else {
                print(error)
                completionHandlerForLocationData(false, nil, "Location data not found for the entered string, please try again!!")
            }
        })
    }
    
    // display an error if something goes wrong
    private func displayError(_ errorString: String?) {
        
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
