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
                        
                        completionHandler(success, errorString)
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
        
        let parameters = [String: AnyObject]()
        let method = Methods.Session
        
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.UserName)\": \"\(userName)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        _ = taskForPOSTMethod(forParseClient: false, method: method, parameters: parameters, jsonBody: jsonBody, completionHandlerForPOST: { (results, error) in
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
                                print("Could not find \(JSONResponseKeys.sessionID) in \(sessionInfo)")
                                completionHandlerForSession(false, nil, nil, "Login Failed (Post Session to Udacity)")
                            }
                        } else {
                            print("Could not find \(JSONResponseKeys.Session) in \(results)")
                            completionHandlerForSession(false, nil, nil, "Login Failed (Post Session to Udacity)")
                        }
                    } else {
                        print("Could not find \(JSONResponseKeys.Key) in \(accountInfo)")
                        completionHandlerForSession(false, nil, nil, "Login Failed (Post Session to Udacity)")
                    }
                } else {
                     print("Could not find \(JSONResponseKeys.Account) in \(results)")
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
                            print("Could not find \(JSONResponseKeys.LastName) in \(userInfo)")
                            completionHandlerForPublicData(false, nil, nil, "Login failed (Public Data from Udacity)")
                        }
                    }
                    else {
                        print("Could not find \(JSONResponseKeys.FirstName) in \(userInfo)")
                        completionHandlerForPublicData(false, nil, nil, "Login failed (Public Data from Udacity)")
                    }
                } else {
                    print("Could not find \(JSONResponseKeys.User) in \(results)")
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
                    print("Could not find \(UdacityParseClient.JSONResponseKeys.StudentInformationResults) in \(results)")
                    completionHandlerForStudentLocations(false, nil, "Error while retrieving Student Locations")
                }
                
            }
        })
    }

}
