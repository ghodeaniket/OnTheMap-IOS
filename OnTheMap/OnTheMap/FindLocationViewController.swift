//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/12/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {

    // MARK: Properties

    var mapAnnotation: CLPlacemark?
    var mapCooardinates: CLLocationCoordinate2D!
    var placeDescription: String!
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationDescriptionTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let mapAnnotation = mapAnnotation {
            let location = mapAnnotation.location
            placeDescription = "\(mapAnnotation.name!), \(mapAnnotation.administrativeArea!)"
            mapCooardinates = location?.coordinate
            addMapLocations()
            centerMapOnLocation(location: mapAnnotation.location!)
        }
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        ActivityIndicator.sharedInstance().startActivityIndicator(self)
        
        guard let urlString = locationDescriptionTextfield.text, let urlToOpen = URL(string: urlString) else {
            ActivityIndicator.sharedInstance().stopActivityIndicator(self)
            print("No url entered")
            self.showError("No URL Entered!")
            return
        }
        if UIApplication.shared.canOpenURL(urlToOpen) {
        
            let hasAddedLocation = UdacityClient.sharedInstance().hasAddedLocation

            UdacityClient.sharedInstance().saveStudentLocation(shouldUpdateLocation: hasAddedLocation, mapString: placeDescription, mediaURL: locationDescriptionTextfield.text!, latitude: mapCooardinates.latitude, longitude: mapCooardinates.longitude) { (success, errorString) in
                performUIUpdatesOnMain {
                    ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                    if success {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        if let errorString = errorString {
                            self.showError(errorString)
                        } else {
                            self.showError("Unknown Error!")
                        }
                    }
                }
            }
        } else {
            ActivityIndicator.sharedInstance().stopActivityIndicator(self)
            showError("Please enter a valid URL")
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    private func addMapLocations() {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = mapAnnotation?.location?.coordinate
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        if let firstName = UdacityClient.sharedInstance().firstName, let lastName = UdacityClient.sharedInstance().lastName {
            annotation.title = "\(firstName) \(lastName)"
        }
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
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

extension FindLocationViewController: MKMapViewDelegate {
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "studentLocation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.image = #imageLiteral(resourceName: "icon_pin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [String: Any](), completionHandler: nil)
            }
        }
    }
}

//MARK:- TextField Delegate
extension FindLocationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


