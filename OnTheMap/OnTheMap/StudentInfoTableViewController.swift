//
//  StudentInfoTableViewController.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/10/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class StudentInfoTableViewController: UITableViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var studentsInformation = [UdacityStudentInformation]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UdacityClient.sharedInstance().getStudentLocations { (success, studentsInfo, errorString) in
            if(success){
                performUIUpdatesOnMain {
                    self.studentsInformation = studentsInfo!
                    
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentsInformation.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInformation", for: indexPath)

        let studentInformation = studentsInformation[indexPath.row]
        
        let studentName = "\(studentInformation.firstName) \(studentInformation.lastName)"
        
        cell.textLabel?.text = studentName

        return cell
    }
}
