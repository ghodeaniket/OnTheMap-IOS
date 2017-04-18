//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/12/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authenticateUser(userName: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        postUserSession(userName, password) { (success, sessionID, accountKey, errorString) in
            if success {
                
                // success, we have a sessionID and accountKey for logged in user.
                
                self.sessionID = sessionID
                self.accountKey = accountKey
                
                self.getStudentPublicData(accountKey, { (success, firstName, lastName, errorString) in
                    if success {
                        
                        // Success, we have user's first and last name
                        self.firstName = firstName
                        self.lastName = lastName
                
                        self.getCurrentStudentLocation({ (success, errorString) in
                            // even if this call fails the error is not propogated to the caller to avoid confusion.
                            completionHandler(true, nil)
                        })
                        
                        
                    } else {
                        completionHandler(success, errorString)
                    }
                })
            } else {
                completionHandler(success, errorString)
            }
        }
    }
    
    private func postUserSession(_ userName: String, _ password: String, _ completionHandlerForSession: @escaping (_ success: Bool, _ sessionId: String?, _ accountKey: String?, _ errorString: String?) -> Void) {
        
//        let parameters = [String: AnyObject]()
        let method = Methods.Session
        
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.UserName)\": \"\(userName)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        let parameters = [
            "udacity": [
                "username": userName,
                "password": password
            ]
        ]
        
        _ = taskForPOSTMethod(forParseClient: false, method: method, parameters: parameters as [String : AnyObject], jsonBody: jsonBody, completionHandlerForPOST: { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForSession(false, nil, nil, "Login failed (Post Session to Udacity)")
            } else {
                if let accountInfo = results?[JSONResponseKeys.Account] as? [String: AnyObject]?{
                    if let accountKey = accountInfo![JSONResponseKeys.Key] as? String? {
                        if let sessionInfo = results?[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject]? {
                            if let sessionID = sessionInfo![UdacityClient.JSONResponseKeys.sessionID] as? String? {
                                completionHandlerForSession(true, sessionID, accountKey, nil)
                            } else {
                                print("Could not find \(JSONResponseKeys.sessionID) in \(String(describing: sessionInfo))")
                                completionHandlerForSession(false, nil, nil, "Login Failed (Post Session to Udacity)")
                            }
                        } else {
                            print("Could not find \(JSONResponseKeys.Session) in \(String(describing: results))")
                            completionHandlerForSession(false, nil, nil, "Login Failed (Post Session to Udacity)")
                        }
                    } else {
                        print("Could not find \(JSONResponseKeys.Key) in \(String(describing: accountInfo))")
                        completionHandlerForSession(false, nil, nil, "Login Failed (Post Session to Udacity)")
                    }
                } else {
                     print("Could not find \(JSONResponseKeys.Account) in \(String(describing: results))")
                    completionHandlerForSession(false, nil, nil, "Login Failed (Post Session to Udacity)")
                }
            }
        })
    }
    
    private func getStudentPublicData(_ accountKey: String?, _ completionHandlerForPublicData: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: String?) -> Void){
        let parameters = [String: AnyObject]()
        var mutableMethod: String = Methods.PublicData
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: accountKey!)!
        
        _ = taskForGETMethod(forParseClient: false, method: mutableMethod, parameters: parameters, completionHandlerForGET: { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForPublicData(false, nil, nil, "Login failed (Public Data from Udacity)")
            } else {
                if let userInfo = results?[JSONResponseKeys.User] as? [String: AnyObject]? {
                    if let firstName = userInfo?[JSONResponseKeys.FirstName] as? String? {
                        if let lastName = userInfo?[JSONResponseKeys.LastName] as? String? {
                            completionHandlerForPublicData(true, firstName, lastName, nil)
                        }else {
                            print("Could not find \(JSONResponseKeys.LastName) in \(String(describing: userInfo))")
                            completionHandlerForPublicData(false, nil, nil, "Login failed (Public Data from Udacity)")
                        }
                    }
                    else {
                        print("Could not find \(JSONResponseKeys.FirstName) in \(String(describing: userInfo))")
                        completionHandlerForPublicData(false, nil, nil, "Login failed (Public Data from Udacity)")
                    }
                } else {
                    print("Could not find \(JSONResponseKeys.User) in \(String(describing: results))")
                    completionHandlerForPublicData(false, nil, nil, "Login failed (Public Data from Udacity)")
                }
            }
        })
        
    }
    
    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ success: Bool, _ studentInformations: [UdacityStudentInformation]?, _ errorString: String?) -> Void) {
        let parameters = ["limit": 100, "order": "updatedAt"] as [String : AnyObject]
   
        let method = Methods.StudentLocation
        
        _ = taskForGETMethod(forParseClient: true, method: method, parameters: parameters, completionHandlerForGET: { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForStudentLocations(false, nil, "Error while retrieving Student Locations")
            } else {
                if let results = results?[UdacityParseClient.JSONResponseKeys.StudentInformationResults] as? [[String: AnyObject]] {
                    let studentsInfo = UdacityStudentInformation.studentInformationFromResults(results)
                    completionHandlerForStudentLocations(true, studentsInfo, nil)
                } else {
                    print("Could not find \(UdacityParseClient.JSONResponseKeys.StudentInformationResults) in \(String(describing: results))")
                    completionHandlerForStudentLocations(false, nil, "Error while retrieving Student Locations")
                }
                
            }
        })
    }
    
    func getCurrentStudentLocation(_ completionHandlerForStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
     
        let parameters = ["where": "{\"uniqueKey\":\"\(accountKey!)\"}"] as [String : AnyObject]
        let method = Methods.StudentLocation
        
        _ = taskForGETMethod(forParseClient: true, method: method, parameters: parameters, completionHandlerForGET: { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForStudentLocation(false, "Error while retrieving Student Locations")
            } else {
                if let results = results?[UdacityParseClient.JSONResponseKeys.StudentInformationResults] as? [[String: AnyObject]] {
                    let studentsInfo = UdacityStudentInformation.studentInformationFromResults(results)
                    if studentsInfo.count > 0 {
                        self.hasAddedLocation = true
                    }
                    completionHandlerForStudentLocation(true, nil)
                } else {
                    print("Could not find \(UdacityParseClient.JSONResponseKeys.StudentInformationResults) in \(String(describing: results))")
                    completionHandlerForStudentLocation(false, "Error while retrieving Student Locations")
                }
                
            }
        })
    }
    
    func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForPostingLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let parameters = [
            "uniqueKey" : accountKey!,
            "firstName": firstName!,
            "lastName": lastName!,
            "mapString": mapString,
            "mediaURL": mediaURL,
            "latitude": latitude,
            "longitude": longitude,
            ] as [String : Any]
        
        let method = Methods.StudentLocation
        
        _ = taskForPOSTMethod(forParseClient: true, method: method, parameters: parameters as [String: AnyObject], jsonBody: "", completionHandlerForPOST: { (results, error) in
            if let _ = results?[JSONResponseKeys.ObjectID] as? String {
                completionHandlerForPostingLocation(true, nil)
            } else {
                print("Could not find \(JSONResponseKeys.ObjectID) in \(String(describing: results))")
                completionHandlerForPostingLocation(false, "Error while retrieving Student Locations")
            }
        })        
    }
}
