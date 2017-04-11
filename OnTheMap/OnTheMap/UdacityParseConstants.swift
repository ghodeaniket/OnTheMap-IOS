//
//  UdacityParseConstants.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/10/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation

extension UdacityParseClient {
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let ErrorMessage = "error"
        static let StatusCode = "status"
        
        //MARK: Student Information
        static let FirstName                 = "firstName"
        static let LastName                  = "lastName"
        static let Longitude                 = "longitude"
        static let Lattitude                 = "latitude"
        static let MapString                 = "mapString"
        static let MediaURL                  = "mediaURL"
        static let UpdatedAt                 = "updatedAt"
        static let StudentInformationResults = "results"        
    }
}
