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
        
        let parameters = [
            "udacity": [
                "username": userName,
                "password": password
            ]
        ]
        
        _ = taskForPOSTMethod(forParseClient: false, method: method, parameters: parameters as [String : AnyObject], completionHandlerForPOST: { (results, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandlerForSession(false, nil, nil, "Login failed (\(error.localizedDescription))")
            } else {
                if let accountInfo = results?[JSONResponseKeys.Account] as? [String: AnyObject]?{
                    if let accountKey = accountInfo![JSONResponseKeys.Key] as? String? {
                        if let sessionInfo = results?[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject]? {
                            if let sessionID = sessionInfo![UdacityClient.JSONResponseKeys.sessionID] as? String? {
                                completionHandlerForSession(true, sessionID, accountKey, nil)
                            } else {
                                print("Could not find \(JSONResponseKeys.sessionID) in \(String(describing: sessionInfo))")
                                completionHandlerForSession(false, nil, nil, "Login Failed (sessionID)")
                            }
                        } else {
                            print("Could not find \(JSONResponseKeys.Session) in \(String(describing: results))")
                            completionHandlerForSession(false, nil, nil, "Login Failed (Session)")
                        }
                    } else {
                        print("Could not find \(JSONResponseKeys.Key) in \(String(describing: accountInfo))")
                        completionHandlerForSession(false, nil, nil, "Login Failed (Key)")
                    }
                } else {
                     print("Could not find \(JSONResponseKeys.Account) in \(String(describing: results))")
                    completionHandlerForSession(false, nil, nil, "Login Failed (Account)")
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
    
    func logoutUserSession(completionHandlerForLogoutUser: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let method = Methods.Session
        
        _ = taskForDELETEMethod(forParseClient: false, method: method, completionHandlerForDELETE: { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForLogoutUser(false, "Error while logging out.")
            } else {
                completionHandlerForLogoutUser(true, nil)
            }
        })
        
    }
    
    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters = ["limit": 100, "order": "-updatedAt"] as [String : AnyObject]
   
        let method = Methods.StudentLocation
        
        _ = taskForGETMethod(forParseClient: true, method: method, parameters: parameters, completionHandlerForGET: { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForStudentLocations(false, "Error while retrieving Student Locations")
            } else {
                if let results = results?[JSONResponseKeys.StudentInformationResults] as? [[String: AnyObject]] {
                    StudentDataSource.sharedInstance.studentData = UdacityStudentInformation.studentInformationFromResults(results)
                    completionHandlerForStudentLocations(true, nil)
                } else {
                    print("Could not find \(JSONResponseKeys.StudentInformationResults) in \(String(describing: results))")
                    completionHandlerForStudentLocations(false, "Error while retrieving Student Locations")
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
                if let results = results?[JSONResponseKeys.StudentInformationResults] as? [[String: AnyObject]] {
                    let studentsInfo = UdacityStudentInformation.studentInformationFromResults(results)
                    if studentsInfo.count > 0 {
                        self.hasAddedLocation = true
                        self.objectID = studentsInfo[0].objectID
                    }
                    completionHandlerForStudentLocation(true, nil)
                } else {
                    print("Could not find \(JSONResponseKeys.StudentInformationResults) in \(String(describing: results))")
                    completionHandlerForStudentLocation(false, "Error while retrieving Student Locations")
                }
                
            }
        })
    }
    
    func saveStudentLocation(shouldUpdateLocation: Bool,mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForSavingLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let parameters = [
            "uniqueKey" : accountKey!,
            "firstName": firstName!,
            "lastName": lastName!,
            "mapString": mapString,
            "mediaURL": mediaURL,
            "latitude": latitude,
            "longitude": longitude,
            ] as [String : Any]
        
        var mutableMethod = Methods.StudentLocation
        
        
        if shouldUpdateLocation {
            
            mutableMethod = Methods.UpdateStudentLocation
            mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: objectID!)!
            _ = taskForPUTMethod(forParseClient: true, method: mutableMethod, parameters: parameters as [String: AnyObject], completionHandlerForPUT: { (results, error) in
                if let _ = results?[UdacityStudentInformation.StudentInformationKeys.UpdatedAt] as? String {
                    completionHandlerForSavingLocation(true, nil)
                } else {
                    print("Could not find \(UdacityStudentInformation.StudentInformationKeys.UpdatedAt) in \(String(describing: results))")
                    completionHandlerForSavingLocation(false, "Error while Updating Student Locations")
                }
            })
        
            
        } else {
            _ = taskForPOSTMethod(forParseClient: true, method: mutableMethod, parameters: parameters as [String: AnyObject], completionHandlerForPOST: { (results, error) in
                if let _ = results?[UdacityStudentInformation.StudentInformationKeys.ObjectID] as? String {
                    completionHandlerForSavingLocation(true, nil)
                } else {
                    print("Could not find \(UdacityStudentInformation.StudentInformationKeys.ObjectID) in \(String(describing: results))")
                    completionHandlerForSavingLocation(false, "Error while Saving Student Locations")
                }
            })
        }
        
    }
}
