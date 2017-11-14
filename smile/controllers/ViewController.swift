//
//  ViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 24/10/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


//UITextField : override textRect, editingRect, This class is defined to give left padding in the TextField.
//Select LeftPaddedTextField as the class for the TextField from the Storyboard.
class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 50, y: bounds.origin.y, width: bounds.width - 70, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 50, y: bounds.origin.y, width: bounds.width - 70 , height: bounds.height)
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userName: LeftPaddedTextField!
    @IBOutlet weak var password: LeftPaddedTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    //@IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var infoDisplayLabel: UILabel!
    
    
    // Function defined to navigate the TextField to new TextField on pressing Next on the keyboard.
    // Tor run this function "tags" should be set for the individual TextField in incremental Order.
    // & the delegate for the TextField should be the ViewController.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        let tag = textField.tag + 1 as Int
        let nextField: UIResponder? = textField.superview?.viewWithTag(tag)
        
        if let field: UIResponder = nextField{
            field.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    // Forget Password button Pressed
    @IBAction func resetPassword(_ sender: Any) {
        if (userName.text != ""){
            let email = userName.text!
            print("Email is \(email)")
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if (error == nil){
                    self.infoDisplayLabel.text = "A Link has been sent to your email for Password Reset. Kindly reset Password by going to that link. Email may take upto 5 min to arrive in your Mailbox"
                }else{
                    self.infoDisplayLabel.text = error!.localizedDescription
                    print(error!.localizedDescription)
                }
            }
        }else{
            print("Displayed Label")
            infoDisplayLabel.text = "Enter UserName, then press Forger Password Button"
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let loginID = userName.text
        let userPass = password.text
        
        
        Auth.auth().signIn(withEmail: loginID!, password: userPass!) { (user, error) in
            // ...
            if error == nil {
                self.infoDisplayLabel.text = "You are successfully Logged In"
                //self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.performSeguetoUserProfile()
            }else{
                self.infoDisplayLabel.text = "\(error!.localizedDescription)"
            }
        }
    }
    
    // Performing Segue to UserProfile Page
    func performSeguetoUserProfile() {
        print("Perform segue called")
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Auth.auth().currentUser?.uid) != nil{
            let email = Auth.auth().currentUser?.email
            print("The user is already signed in. as \(email)")
            performSeguetoUserProfile() // Performing seque to UserProfile page of the user is already signed in.
        }
        else{
            print("tHE USER IS NOR SIGNED IN ")
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        infoDisplayLabel.numberOfLines = 5  // Displaying Multiple Line Label
        
        infoDisplayLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 16.0)
        infoDisplayLabel.textColor = UIColor.red
        
        userName.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        userName.textColor = UIColor.black
        
        password.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        password.textColor = UIColor.black
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

