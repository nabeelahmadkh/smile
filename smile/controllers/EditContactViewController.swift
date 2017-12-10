//
//  EditContactViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 11/26/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EditTextViewController: UIViewController {
    @IBOutlet weak var contactName1: UITextField!
    @IBOutlet weak var contactMobile1: UITextField!
    @IBOutlet weak var contactName2: UITextField!
    @IBOutlet weak var contactMobile2: UITextField!
    @IBOutlet weak var contactName3: UITextField!
    @IBOutlet weak var contactMobile3: UITextField!
    
    let ref = Database.database().reference().root
    let uid = Auth.auth().currentUser?.uid
    var numberOfEmergencyContacts = 0
    let userDatabase:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        var gender:String = ""
        
        if let userInfo = userDatabase.dictionary(forKey: "userInfo") {
            print("UserInfo = \(userInfo)")
            gender = (userInfo["gender"] as! String).lowercased()
            print("Gender = \(gender)")
        }
        
        self.view = GradientSelector().setGradient(view: self.view,type: gender)
        
        ref.child("users").child(uid!).child("emergency_contacts").child("contact1").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let contactName = value?["name"] as? String ?? ""
            let contactMobile = value?["phone"] as? String ?? ""
            print("the contacts are \(contactName) \(contactMobile)")
            self.contactName1.text = contactName
            self.contactMobile1.text = contactMobile
        }) { (error) in
            print(error.localizedDescription)
        }
        ref.child("users").child(uid!).child("emergency_contacts").child("contact2").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let contactName = value?["name"] as? String ?? ""
            let contactMobile = value?["phone"] as? String ?? ""
            print("the contacts2 are \(contactName) \(contactMobile)")
            self.contactName2.text = contactName
            self.contactMobile2.text = contactMobile
        }) { (error) in
            print(error.localizedDescription)
        }
        ref.child("users").child(uid!).child("emergency_contacts").child("contact3").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let contactName = value?["name"] as? String ?? ""
            let contactMobile = value?["phone"] as? String ?? ""
            print("the contacts3 are \(contactName) \(contactMobile)")
            self.contactName3.text = contactName
            self.contactMobile3.text = contactMobile
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func updateContactDetails(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "OK", style: .default, handler: goToDash)
        alert.addAction(okaction)
        
        if(contactName1.text != "") {
            if(contactMobile1.text == "") {
                alert.title = "Mobile Number Missing"
                alert.message = "Mobile Number for Contact 1 should not be blank."
                self.present(alert, animated: true, completion: nil)
            } else {
                ref.child("users").child(uid!).child("emergency_contacts").child("contact1").child("name").setValue(contactName1.text)
                ref.child("users").child(uid!).child("emergency_contacts").child("contact1").child("phone").setValue(contactMobile1.text)
            }
        }
        
        if(contactName2.text != "") {
            if(contactMobile2.text == "") {
                alert.title = "Mobile Number Missing"
                alert.message = "Mobile Number for Contact 2 should not be blank."
                self.present(alert, animated: true, completion: nil)
            }else {
                ref.child("users").child(uid!).child("emergency_contacts").child("contact2").child("name").setValue(contactName2.text)
                ref.child("users").child(uid!).child("emergency_contacts").child("contact2").child("phone").setValue(contactMobile2.text)
            }
        }
        
        if(contactName3.text != "") {
            if(contactMobile3.text == "") {
                alert.title = "Mobile Number Missing"
                alert.message = "Mobile Number for Contact 3 should not be blank."
                self.present(alert, animated: true, completion: nil)
            }else {
                ref.child("users").child(uid!).child("emergency_contacts").child("contact3").child("name").setValue(contactName3.text)
                ref.child("users").child(uid!).child("emergency_contacts").child("contact3").child("phone").setValue(contactMobile3.text)
            }
        }
        alert.title = "Emergency Contacts Added"
        alert.message = "Emergency Contacts Successfully Added."
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func goToDash(alert : UIAlertAction!){
        print("Perform go to dashboard segue called")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard_Navigation")
        self.present(controller, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var gender:String = ""
        
        if let userInfo = userDatabase.dictionary(forKey: "userInfo") {
            print("UserInfo = \(userInfo)")
            gender = (userInfo["gender"] as! String).lowercased()
            print("Gender = \(gender)")
        }
        
        self.view = GradientSelector().setGradient(view: self.view,type: gender)
    }
}
