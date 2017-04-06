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
        static let AuthorizationURL = "https://www.udacity.com/api/session"
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
        
    }

}
