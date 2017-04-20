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

    // MARK: Properties
    
    var keyboardOnScreen = false
    var location: CLPlacemark?
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    @IBAction func findLocationOnMap(_ sender: Any) {
        if locationTextField.text!.isEmpty {
            print("Empty string for location")
            displayError("Please enter location")
            return
        }
        
        ActivityIndicator.sharedInstance().startActivityIndicator(self)
        
        getLocationData(fromSearchString: locationTextField.text!) { (success, placeMark, errorString) in            
            performUIUpdatesOnMain {
                ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                if (success) {
                    self.location = placeMark
                    self.performSegue(withIdentifier: "findLocation", sender: self)
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation" {
            let findLocationVC = segue.destination as! FindLocationViewController
            findLocationVC.mapAnnotation = self.location
        }
    }
    
    private func getLocationData(fromSearchString searchString: String, completionHandlerForLocationData: @escaping (_ success: Bool, _ locationData: CLPlacemark?, _ errorString: String?) -> Void ){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchString, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemark = placemarks?[0] {
                completionHandlerForLocationData(true, placemark, nil)
            } else {
                if let error = error {
                    print(error)
                }
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

//MARK:- TextField Delegate
extension PostInformationViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            // Move View just enough to show the Find Location button
            view.frame.origin.y -= findLocationButton.frame.origin.y + 20.0
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

// MARK: - PostInformationViewController (Notifications)

private extension PostInformationViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
