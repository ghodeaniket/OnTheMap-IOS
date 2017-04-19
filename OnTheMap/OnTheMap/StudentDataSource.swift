//
//  StudentDataSource.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/19/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class StudentDataSource: NSObject {
    var studentData = [UdacityStudentInformation]()
    static let sharedInstance = StudentDataSource()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
}
