//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/6/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

// MARK: - UdacityClient (Constants)

import Foundation

extension UdacityClient {
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL = "https://www.udacity.com/api"
    }
    
    struct ParseConstants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

    }
    
    struct Methods {
        static let Session = "/session"
        static let PublicData = "/users/{id}"
        
        static let StudentLocation = "/StudentLocation"
        static let UpdateStudentLocation = "/StudentLocation/{id}"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let ErrorMessage = "error"
        static let StatusCode = "status"
        
        // MARK: General
        static let Account = "account"
        static let Session = "session"
        
        // MARK: Account
        static let RegisterationFlag = "registered"
        static let Key = "key"
        
        // MARK: Session
        static let Expiration = "expiration"
        static let sessionID = "id"
        
        // MARK: User Public Data
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let User = "user"
        
        // Results
        
        static let StudentInformationResults = "results"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let UserName = "username"
        static let Password = "password"        
    }

}
