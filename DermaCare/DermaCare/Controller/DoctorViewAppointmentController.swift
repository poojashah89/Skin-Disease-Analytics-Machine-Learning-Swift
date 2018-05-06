//
//  DoctorViewAppointmentController.swift
//  DermaCare
//
//  Created by sindhya on 5/3/18.
//  Copyright © 2018 Pooja. All rights reserved.
//

import UIKit
import Firebase

class DoctorViewAppointmentController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var docAppointmentTableView: UITableView!
    
    @IBOutlet weak var numAppmtLabel: UILabel!
    
    
    var docAppointmentList=Array<DoctorAppointmentModel>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func fetchDoctorAppointmentData(){
        let rootRef = Database.database().reference()
        let refuser = rootRef.child("userlist")
        let userID: String = (Auth.auth().currentUser?.uid)!
        refuser.child(userID).child("appointments").observe(.value, with: {(snapshot) in
            if let users = snapshot.value as? [String:AnyObject] {
                for (key, user) in users {
                    let patient  = user["patient"] as? String
                    let patItem = DoctorAppointmentModel(patName: patient!, date: key)
                
                    self.docAppointmentList.append(patItem)
                    DispatchQueue.main.async(execute: {
                        self.docAppointmentTableView.reloadData()
                    })
                }
            }
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.docAppointmentList.count > 0) {
            self.numAppmtLabel.text = "You have \(docAppointmentList.count) appointments!"
            return docAppointmentList.count;
        }
        else {
            self.numAppmtLabel.text = "You have no appointments!"
            tableView.separatorStyle = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = docAppointmentTableView.dequeueReusableCell(withIdentifier: "DocAppointmentTableViewCell") as? DocAppointmentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.patientName.text = docAppointmentList[indexPath.row].patientName
        cell.appmtDate.text = docAppointmentList[indexPath.row].date
        return cell;
    }

}