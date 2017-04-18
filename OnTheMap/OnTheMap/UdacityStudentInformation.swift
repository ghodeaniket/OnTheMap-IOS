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
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary[StudentInformationKeys.FirstName] as! String
        lastName = dictionary[StudentInformationKeys.LastName] as! String
        longitude = dictionary[StudentInformationKeys.Longitude] as! Double
        lattitude = dictionary[StudentInformationKeys.Lattitude] as! Double
        mapString = dictionary[StudentInformationKeys.MapString] as! String
        mediaURL = dictionary[StudentInformationKeys.MediaURL] as! String
        updatedAt = dictionary[StudentInformationKeys.UpdatedAt] as! String
        objectID = dictionary[StudentInformationKeys.ObjectID] as! String
    }
    
    static func studentInformationFromResults(_ results: [[String: AnyObject]]) -> [UdacityStudentInformation] {
        var studentsInformation = [UdacityStudentInformation]()
        // iterate through array of dictionaries, each StudentInformation is a dictionary
        for result in results {
            studentsInformation.append(UdacityStudentInformation(dictionary: result))
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
