//
//  UdacityStudentInformation.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/10/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation

struct UdacityStudentInformation {
    
    let firstName: String
    let lastName: String
    let longitude: Double
    let lattitude: Double
    let mapString: String
    let mediaURL: String
    let updatedAt: String
    let objectID: String
    
    // MARK: Initializers
    
    // construct a UdacityStudentInformation from a dictionary
    
    init?(dictionary: [String: AnyObject]) {
        
        // check if location information and objectID is absent, if it is then dont add it to the data source
        guard (dictionary[StudentInformationKeys.Longitude] as? Double) != nil else {
            return nil
        }
        guard (dictionary[StudentInformationKeys.Lattitude] as? Double) != nil else {
            return nil
        }
        guard (dictionary[StudentInformationKeys.MediaURL] as? String) != nil else {
            return nil
        }
        
        firstName = dictionary[StudentInformationKeys.FirstName] as? String ?? " "
        lastName = dictionary[StudentInformationKeys.LastName] as? String ?? " "
        longitude = dictionary[StudentInformationKeys.Longitude] as! Double
        lattitude = dictionary[StudentInformationKeys.Lattitude] as! Double
        mapString = dictionary[StudentInformationKeys.MapString] as? String ?? " "
        mediaURL = dictionary[StudentInformationKeys.MediaURL] as! String
        updatedAt = dictionary[StudentInformationKeys.UpdatedAt] as? String ?? " "
        objectID = dictionary[StudentInformationKeys.ObjectID] as! String
    }
    
    static func studentInformationFromResults(_ results: [[String: AnyObject]]) -> [UdacityStudentInformation] {
        var studentsInformation = [UdacityStudentInformation]()
        // iterate through array of dictionaries, each StudentInformation is a dictionary
        for result in results {
            if let studentInformation = UdacityStudentInformation(dictionary: result) {
                studentsInformation.append(studentInformation)
            }
        }
        return studentsInformation
    }
    
    
    struct StudentInformationKeys {
        static let FirstName                 = "firstName"
        static let LastName                  = "lastName"
        static let Longitude                 = "longitude"
        static let Lattitude                 = "latitude"
        static let MapString                 = "mapString"
        static let MediaURL                  = "mediaURL"
        static let UpdatedAt                 = "updatedAt"
        static let ObjectID                  = "objectId"
    }
    
}
