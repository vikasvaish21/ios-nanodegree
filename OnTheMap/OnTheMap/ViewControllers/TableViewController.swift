//
//  TableViewController.swift
//  OnTheMap
//
//  Created by vikas on 19/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    
    let tableCellID = "PinTableCell"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadStudentLocations()
    }

    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadStudentLocations()
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        NetworkManager.logout { (errorMessage) in
            if let error = errorMessage {
                DataTaskController.showSimpleAlert(viewController: self,
                                        title: "Failed to Logout", message: error)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
   func loadStudentLocations() {
        NetworkManager.getUniqueStudentLocation(type: .allLocations) { (locations, errorMessage) in
            if let error = errorMessage {
                DataTaskController.showSimpleAlert(viewController: self,
                                        title: "Failed to Get Locations", message: error)
            }
            else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Parse.studentLocations!.count
    }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID) as! PinTableCell
        let student = (Parse.studentLocations![indexPath.row])
        cell.nameLabel.text = student.mapString
        cell.mediaLabel.text = student.mediaURL
        return cell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
            tableView.deselectRow(at: indexPath, animated: true)
            let mediaUrl = Parse.studentLocations![indexPath.row].mediaURL
            if let  toOpen = mediaUrl{
                if canVerifyUrl(urlString:toOpen){
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
                else{
                    showAlert("the URL was not valid and could not be opened")
            }
        }
    }
    
    
        func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
      func canVerifyUrl(urlString:String?) -> Bool{
        if let URLString = urlString{
            if let url = NSURL(string: URLString){
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
