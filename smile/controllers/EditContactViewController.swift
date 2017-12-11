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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contact1Label: UILabel!
    @IBOutlet weak var name1Label: UILabel!
    @IBOutlet weak var mobile1Label: UILabel!
    @IBOutlet weak var contact2Label: UILabel!
    @IBOutlet weak var name2Label: UILabel!
    @IBOutlet weak var mobile2Label: UILabel!
    @IBOutlet weak var contact3Label: UILabel!
    @IBOutlet weak var name3Label: UILabel!
    @IBOutlet weak var mobile3Label: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var name1Text: UITextField!
    @IBOutlet weak var mobile1Text: UITextField!
    @IBOutlet weak var name2Text: UITextField!
    @IBOutlet weak var mobile2Text: UITextField!
    @IBOutlet weak var name3Text: UITextField!
    @IBOutlet weak var mobile3Text: UITextField!
    
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
        
        titleLabel.backgroundColor = AppDelegate.buttonColor
        titleLabel.textColor = AppDelegate.buttonTextColor
        
        contact1Label.backgroundColor = AppDelegate.labelColor
        contact1Label.textColor = AppDelegate.labelTextColor
        contact2Label.backgroundColor = AppDelegate.labelColor
        contact2Label.textColor = AppDelegate.labelTextColor
        contact3Label.backgroundColor = AppDelegate.labelColor
        contact3Label.textColor = AppDelegate.labelTextColor
        
        name1Label.backgroundColor = AppDelegate.labelColor
        name1Label.textColor = AppDelegate.labelTextColor
        name2Label.backgroundColor = AppDelegate.labelColor
        name2Label.textColor = AppDelegate.labelTextColor
        name3Label.backgroundColor = AppDelegate.labelColor
        name3Label.textColor = AppDelegate.labelTextColor
        
        mobile1Label.backgroundColor = AppDelegate.labelColor
        mobile1Label.textColor = AppDelegate.labelTextColor
        mobile2Label.backgroundColor = AppDelegate.labelColor
        mobile2Label.textColor = AppDelegate.labelTextColor
        mobile3Label.backgroundColor = AppDelegate.labelColor
        mobile3Label.textColor = AppDelegate.labelTextColor
        
        name1Text.backgroundColor = AppDelegate.textfieldColor
        name1Text.textColor = AppDelegate.labelTextColor
        name2Text.backgroundColor = AppDelegate.textfieldColor
        name2Text.textColor = AppDelegate.labelTextColor
        name3Text.backgroundColor = AppDelegate.textfieldColor
        name3Text.textColor = AppDelegate.labelTextColor
        
        mobile1Text.backgroundColor = AppDelegate.textfieldColor
        mobile1Text.textColor = AppDelegate.labelTextColor
        mobile2Text.backgroundColor = AppDelegate.textfieldColor
        mobile2Text.textColor = AppDelegate.labelTextColor
        mobile3Text.backgroundColor = AppDelegate.textfieldColor
        mobile3Text.textColor = AppDelegate.labelTextColor
        
        updateButton.backgroundColor = AppDelegate.buttonColor
        updateButton.setTitleColor(AppDelegate.buttonTextColor, for: UIControlState.selected)
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
