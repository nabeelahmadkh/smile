//
//  TextViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 14/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MessageUI

class TextViewController: UIViewController, MFMessageComposeViewControllerDelegate  {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var smsText: UITextView!
    @IBOutlet weak var notice: UILabel!
    @IBOutlet weak var sendSMSButton: UIButton!
    
    var contactNumbers:[String]! = []
    
    var ref: DatabaseReference!
    
    //var contacts:[String: String] = ["Abhijeet Kharkar":"319-512-8180"]
    var contacts:[String: String] = [:]
    
    override func viewDidLoad() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear call __1__")
        
        
        
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        let tableRef = ref.child("users").child(uid!).child("emergency_contacts")
        
        tableRef.observeSingleEvent(of : .value, with: { snapshot in
            if snapshot.hasChildren() {
                print("Snapshot has \(snapshot.childrenCount) children")
                
                let records : [DataSnapshot] = snapshot.children.allObjects as! [DataSnapshot]
                for record in records {
                    print("Record = \(record)")
                    let recordVal : Dictionary<String, String> = record.value as! Dictionary<String, String>
                    //self.contacts.append(recordVal["name"]! + "!#@#!" + recordVal["v_url"]!)
                    
                    self.contacts[recordVal["name"]!] = recordVal["phone"]!
                }
                print("Contacts = \(self.contacts)")
            }
            self.view = GradientSelector().setGradient(view: self.view,type: 0)
            self.smsText.text = "I am feeling low and need someone to converse with. I am not in a state to talk. Do reply."
            if(self.contacts.count == 0) {
                self.sendSMSButton.isEnabled = false
                
                self.smsText.isEditable = false
                self.smsText.isSelectable = false
                self.smsText.isUserInteractionEnabled = false
                self.smsText.isScrollEnabled = false
                
                self.notice.text = "Use \"Edit\" option to add contacts of Trusted Ones."
                self.notice.textColor = UIColor.red
                self.notice.shadowColor = UIColor(red: 193/255, green: 17/255, blue: 1/255, alpha: 1)
                
                let alert = UIAlertController(title: "Details Missing", message: "Please setup your emergency contact information.", preferredStyle: .alert)
                let okaction = UIAlertAction(title: "OK", style: .default, handler: self.callSegue)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: self.goToDashboard)
                alert.addAction(okaction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.sendSMSButton.isEnabled = true
                
                self.smsText.isEditable = true
                self.smsText.isSelectable = true
                self.smsText.isUserInteractionEnabled = true
                self.smsText.isScrollEnabled = true
                
                var noticeText:String = "Your SMS will be sent to:\n"
                for (key, value) in self.contacts {
                    noticeText += key + " (" + value + ")\n"
                    self.contactNumbers.append(value)
                }
                self.notice.text = noticeText
                self.notice.textColor = UIColor(red: 1/255, green: 193/255, blue: 59/255, alpha: 1)
                self.notice.shadowColor = UIColor(red: 1/255, green: 124/255, blue: 38/255, alpha: 1)
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear called __2__")
    }
    
    @IBAction func openEditContacts(_ sender: UIBarButtonItem) {
        print("Perform segue called")
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "contactToEdit", sender: self)
        }
    }
    
    @IBAction func textCallToggler(_ sender: UISegmentedControl) {
        print("Index = \(sender.selectedSegmentIndex)")
        if(sender.selectedSegmentIndex == 0) {
            smsText.text = "I am feeling low and need someone to converse with. I am not in a state to talk. Do reply."
        } else {
            smsText.text = "I am feeling low and need to talk to someone. Please call me asap."
        }
    }
    
    @IBAction func sendSMS(_ sender: UIButton) {
        let messageVC = MFMessageComposeViewController()
        
        print("Contact Numbers = \(contactNumbers)")
        
        messageVC.body = smsText.text;
        messageVC.recipients = contactNumbers
        messageVC.messageComposeDelegate = self;
        
        if MFMessageComposeViewController.canSendText() {
            self.present(messageVC, animated: false, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResult.cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
            break;
        case MessageComposeResult.failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
            break;
        case MessageComposeResult.sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
            break;
        default:
            break;
        }
    }
    
    func callSegue(alert : UIAlertAction!) {
        print("Perform segue called")
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "contactToEdit", sender: self)
        }
    }
    
    func goToDashboard(alert : UIAlertAction!) {
        print("Perform go to dashboard segue called")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard_Navigation")
        self.present(controller, animated: false, completion: nil)
    }
}
