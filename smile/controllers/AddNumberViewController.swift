//
//  addNumberViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 12/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class addNumberViewController: UIViewController{
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().root
        
        if ((nameTextField.text != "") && (numberTextField.text != "")){
            let emergencyContactName = nameTextField.text
            let emergencyContactNumber = numberTextField.text
            ref.child("users").child(uid!).child("EmergencyContactName").setValue(emergencyContactName)
            ref.child("users").child(uid!).child("EmergencyContactNumber").setValue(emergencyContactNumber)
            errorLabel.text = ""
            nameTextField.text = ""
            numberTextField.text = ""
            let alert = UIAlertController(title: "Update", message: "Name & Number Successfully Updated", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "OK", style: .default, handler: backToProfile)
            alert.addAction(okaction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            errorLabel.text = "Name or Password Missing"
        }
    }
    
    // Callback function to go back to Profile Page
    func backToProfile(alert: UIAlertAction!){
        print("__Function back to Profile Called__")
        _ = navigationController?.popViewController(animated: true)
        //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let loginViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "userProfileEdit")
        //self.present(loginViewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        nameTextField = ComponentFormatter().setLabel(nameTextField, 18, UIColor.black, UIColor.darkGray, "Name")
        numberTextField = ComponentFormatter().setLabel(numberTextField, 18, UIColor.black, UIColor.darkGray, "MobileNumber")
        label = ComponentFormatter().setLabel(label, 24, UIColor.black)
        submitButton = ComponentFormatter().setButton(submitButton, 20, UIColor.black)
        errorLabel = ComponentFormatter().setLabel(errorLabel, 18, UIColor.red)
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
}
