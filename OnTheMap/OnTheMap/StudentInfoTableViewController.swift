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
        // create and set the logout button
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
        
        // create and set add information Button
        parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postStudentInformation))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let parameters = ["limit": 100, "order": "updatedAt", "uniqueKey": 4172999640] as [String : AnyObject]
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: appDelegate.udacityURLFromParameters(forParseClient: true, parameters: parameters as [String : AnyObject], withPathExtension: "/StudentLocation"))
        /* 2/3. Build the URL, Configure the request */
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func displayError(_ errorMessage: String) {
                print(errorMessage)
                
                performUIUpdatesOnMain {
//                    self.showError(errorMessage)
//                    self.setUIEnabled(true)
                }
            }
            
            guard (error == nil) else {
                print("Error while logging in user \(String(describing: error))")
                displayError("There was an error connecting to Udacity API")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print("Error while logging in user, (No Data returned).")
                displayError("Couldn't login, Please try again.")
                return
            }
            
            
            var parsedResult : [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            }catch {
                displayError("Could not parse data \(data)")
                return
            }
            
            guard let studentsInformation = parsedResult[UdacityParseClient.JSONResponseKeys.StudentInformationResults] as? [[String: AnyObject]] else {
                displayError("Could not find '\(UdacityParseClient.JSONResponseKeys.StudentInformationResults)' key in '\(parsedResult)'")
                return
            }
            
            self.studentsInformation = UdacityStudentInformation.studentInformationFromResults(studentsInformation)
            
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
        
        task.resume()

        
    }
    
    // MARK: Logout
    
    func logout() {
        dismiss(animated: true, completion: nil)
    }

    func postStudentInformation() {
        let postInformationController = storyboard?.instantiateViewController(withIdentifier: "PostInformationViewController") as! UINavigationController
        present(postInformationController, animated: true, completion: nil)
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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
