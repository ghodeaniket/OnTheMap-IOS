//
//  StudentInfoTableViewController.swift
//  OnTheMap
//
//  Created by Aniket Ghode on 4/10/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class StudentInfoTableViewController: UITableViewController {

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UdacityClient.sharedInstance().getStudentLocations { (success, errorString) in
            
            performUIUpdatesOnMain {
                ActivityIndicator.sharedInstance().stopActivityIndicator(self)
                if success {
                    self.tableView.reloadData()
                }
                else {
                    self.showError("Error occured while retrieving student locations.")
                }
            }           
        }
    }
    
    // MARK: Helpers
    
    fileprivate func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "On The Map", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}



extension StudentInfoTableViewController {
   
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StudentDataSource.sharedInstance.studentData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInformation", for: indexPath)
        
        let studentInformation = StudentDataSource.sharedInstance.studentData[indexPath.row]
        
        let studentName = "\(studentInformation.firstName) \(studentInformation.lastName)"
        
        cell.textLabel?.text = studentName
        
        return cell
    }
    
    // MARK: - Table view data delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let student = StudentDataSource.sharedInstance.studentData[indexPath.row]
        if let url = URL(string: student.mediaURL) {
            app.open(url, options: [:], completionHandler: { (succes) in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
        } else {
            showError("Not a valid URL")
        }
        
    }
}
