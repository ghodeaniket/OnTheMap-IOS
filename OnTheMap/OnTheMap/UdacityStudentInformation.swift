//
//  UdacityStudentInformation.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/10/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation

struct UdacityStudentInformation {
    /*
     createdAt = "2016-07-21T19:37:53.388Z";
     firstName = Salvador;
     lastName = Villa;
     latitude = "44.9707178275793";
     longitude = "-93.26195875000001";
     mapString = Minneapolis;
     mediaURL = "www.google.com";
     objectId = AJvQglDt6u;
     uniqueKey = 4172999640;
     updatedAt = "2016-07-21T19:45:49.133Z";
     
    */
    
    let firstName: String
    let lastName: String
    let longitude: Double
    let lattitude: Double
    let mapString: String
    let mediaURL: String
    let updatedAt: String
    
    // MARK: Initializers
    
    // construct a UdacityStudentInformation from a dictionary
    
    init(dictionary: [String: AnyObject]) {
        firstName = dictionary[UdacityParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityParseClient.JSONResponseKeys.LastName] as! String
        longitude = dictionary[UdacityParseClient.JSONResponseKeys.Longitude] as! Double
        lattitude = dictionary[UdacityParseClient.JSONResponseKeys.Lattitude] as! Double
        mapString = dictionary[UdacityParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[UdacityParseClient.JSONResponseKeys.MediaURL] as! String
        updatedAt = dictionary[UdacityParseClient.JSONResponseKeys.UpdatedAt] as! String
    }
    
    static func studentInformationFromResults(_ results: [[String: AnyObject]]) -> [UdacityStudentInformation] {
        var studentsInformation = [UdacityStudentInformation]()
        // iterate through array of dictionaries, each StudentInformation is a dictionary
        for result in results {
            studentsInformation.append(UdacityStudentInformation(dictionary: result))
        }
        return studentsInformation
    }
    
}
