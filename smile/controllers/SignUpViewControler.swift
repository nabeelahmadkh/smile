//
//  signUpViewController2.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 25/10/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import DLRadioButton
//import DLRadioButton



//UITextField : override textRect, editingRect, This class is defined to give left padding in the TextField.
//Select LeftPaddedTextField as the class for the TextField from the Storyboard.
//This class is different from the class declared in ViewController.swift file
class LeftPaddedTextField2: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width - 30, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width - 30 , height: bounds.height)
    }
}


class signUpViewControler:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Declaring variables for the SignUp View Controler
    @IBOutlet weak var signUpTextLabel: UILabel!
    @IBOutlet weak var usernameTextField: LeftPaddedTextField2!
    @IBOutlet weak var passwordTextField: LeftPaddedTextField2!
    @IBOutlet weak var confirmPasswordTextField: LeftPaddedTextField2!
    var sexButton:String? = nil
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var mobileTextField: LeftPaddedTextField2!
    @IBOutlet weak var dateOfBirthTextField: LeftPaddedTextField2!
    @IBOutlet weak var signUpConfirmationLabel: UILabel!
    @IBOutlet weak var passwordNoMatch: UILabel!
    @IBOutlet weak var imageSelector: UIImageView!
    var noErrorFlag = 0x01
    var imagePicker = UIImagePickerController()
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var userNameNotValid: UILabel!
    @IBOutlet weak var dateInvalid: UILabel!
    var hobbies = [String]()
    var checkBox = UIImage(named: "checked")
    var uncheckBox = UIImage(named: "unchecked")
    @IBOutlet weak var checkBox1: UIButton!
    var box1Checked:Bool = false
    @IBOutlet weak var checkBox2: UIButton!
    var box2Checked:Bool = false
    @IBOutlet weak var checkBox3: UIButton!
    var box3Checked:Bool = false
    @IBOutlet weak var checkBox4: UIButton!
    var box4Checked:Bool = false
    @IBOutlet weak var nameTextField: LeftPaddedTextField2!
    @IBOutlet weak var maleRadioButton: DLRadioButton!
    @IBOutlet weak var femaleRadioButton: DLRadioButton!
    @IBOutlet weak var otherRadioButton: DLRadioButton!
    @IBOutlet weak var hobbylabel3: UILabel!
    @IBOutlet weak var hobbylabel4: UILabel!
    @IBOutlet weak var hobbylabel2: UILabel!
    @IBOutlet weak var hobbylabel1: UILabel!
    @IBOutlet weak var hobbylabel: UILabel!
    var hobbyLabels:[String] = ["Travel", "Technology", "Shopping", "Food"]
    let userDatabase:UserDefaults = UserDefaults.standard
    
    
    //Male Female Other Radio Button Selected
    @IBAction func femaleRadioButtonPressed(_ sender: Any) {
        print("Female Radio Button Selected")
        sexButton = "Female"
    }
    
    @IBAction func maleRadioButtonPressed(_ sender: Any) {
        print("Male Radio Button Selected")
        sexButton = "Male"
    }
    
    @IBAction func otherRadioButtonPressed(_ sender: Any) {
        print("Other Radio Button Selected")
        sexButton = "Other"
    }
    
    // Validating Date is in Correct Format or not
    @IBAction func dateChecker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = dateFormatter.date(from: dateOfBirthTextField.text!){
            print("date format corrrect \(date)")
            dateInvalid.text = ""
            noErrorFlag = 0x02
            
        } else {
            dateInvalid.text = "Date Invalid"
            noErrorFlag = 0x01
            // invalid format
        }
    }
    
    // Check Box Button 1 pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        if box1Checked == false{
            checkBox1.setImage(checkBox, for: UIControlState.normal)
            hobbies.append(hobbyLabels[0])
            box1Checked = true
        }
        else{
            checkBox1.setImage(uncheckBox, for: UIControlState.normal)
            if let index = hobbies.index(of: hobbyLabels[0]){
                hobbies.remove(at: index)
            }
            box1Checked = false
        }
        print("value of hobbies is \(hobbies)")
    }
    
    // Check Box Button 2 pressed
    @IBAction func button2Pressed(_ sender: UIButton) {
        if box2Checked == false{
            checkBox2.setImage(checkBox, for: UIControlState.normal)
            hobbies.append(hobbyLabels[1])
            box2Checked = true
        }
        else{
            checkBox2.setImage(uncheckBox, for: UIControlState.normal)
            if let index = hobbies.index(of: hobbyLabels[1]) {
                hobbies.remove(at: index)
            }
            box2Checked = false
        }
        print("value of hobbies is \(hobbies)")
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        if box3Checked == false{
            checkBox3.setImage(checkBox, for: UIControlState.normal)
            hobbies.append(hobbyLabels[2])
            box3Checked = true
        }
        else{
            checkBox3.setImage(uncheckBox, for: UIControlState.normal)
            if let index = hobbies.index(of: hobbyLabels[2]) {
                hobbies.remove(at: index)
            }
            box3Checked = false
        }
        print("value of hobbies is \(hobbies)")
    }
    
    @IBAction func button4Pressed(_ sender: UIButton) {
        if box4Checked == false{
            checkBox4.setImage(checkBox, for: UIControlState.normal)
            hobbies.append(hobbyLabels[3])
            box4Checked = true
        }
        else{
            checkBox4.setImage(uncheckBox, for: UIControlState.normal)
            if let index = hobbies.index(of: hobbyLabels[3]) {
                hobbies.remove(at: index)
            }
            box4Checked = false
        }
        print("value of hobbies is \(hobbies)")
    }
    
    // Checking Username[Email] is Valid or not
    @IBAction func checkUsername(_ sender: Any) {
        let isEmailValid = isValidEmailAddress(emailAddressString: usernameTextField.text!)
        if isEmailValid == false{
            userNameNotValid.text = "Email not Valid"
            noErrorFlag = 0x01
        }
        else{
            userNameNotValid.text = ""
            noErrorFlag = 0x02
        }
    }
    
    // Function for checking the Username against a Regular Expression
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        // Regular Expression for checking the email
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    // Password Length and Matching Check
    @IBAction func confirmPassword(_ sender: Any) {
        let lengthOfPassword:Int = (confirmPasswordTextField.text?.count)!
        // Checking for password length
        if (lengthOfPassword >= 6){
            // Checking for Password Match
            if (passwordTextField.text == confirmPasswordTextField.text){
                print("Length of Password is greator than or equal to 6")
                noErrorFlag = 0x02
                passwordNoMatch.text = ""
            }
            else{
                passwordNoMatch.text = "NO MATCH!!!"
                noErrorFlag = 0x01
            }
        }
        else{
            passwordNoMatch.text = "LENGTH<6!!!"
            noErrorFlag = 0x01
        }
    }
    
    // SignUp Button Pressed
    @IBAction func signUpButton(_ sender: UIButton) {
        if (noErrorFlag == 0x02){
            let email = usernameTextField.text
            let password = passwordTextField.text
            let sexLabel = sexButton
            let dateOfBirth = dateOfBirthTextField.text
            let mobile = mobileTextField.text
            let hobby = hobbies
            let name = nameTextField.text
            let ref = Database.database().reference().root
            
            // Creating user in FireBase
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user: User?, error) in
                if error == nil {
                    
                    // Adding additional information of the user to the database
                    ref.child("users").child((user?.uid)!).child("email").setValue(email)
                    ref.child("users").child((user?.uid)!).child("dob").setValue(dateOfBirth)
                    ref.child("users").child((user?.uid)!).child("sex").setValue(sexLabel)
                    ref.child("users").child((user?.uid)!).child("mobile").setValue(mobile)
                    ref.child("users").child((user?.uid)!).child("hobby").setValue(hobby)
                    ref.child("users").child((user?.uid)!).child("name").setValue(name)
                    
                    // Upload profile Picture to Firebase Storage and save the reference in the Database.
                    if let imageData:Data = UIImagePNGRepresentation(self.imageSelector.image!)!
                    {
                        let profilePictureStorageRef = self.storageRef.child("userProfiles/\((user?.uid)!)/profilePic")
                        
                        let uploadTask = profilePictureStorageRef.putData(imageData, metadata: nil)
                        {metadata, error in
                            if error == nil{
                                let downloadUrl = metadata!.downloadURL()
                                print("the download link is \(downloadUrl)")
                                ref.child("users").child((user?.uid)!).child("profilePicture").setValue(downloadUrl!.absoluteString)
                                print("The file was uploaded successsfully.")
                                // Logging Out because the user was automatically signing in after registration.
                                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                    print("The user successfully signed out of the app")
                                } catch let signOutError as NSError {
                                    print ("Error signing out: %@", signOutError)
                                }
                                DispatchQueue.main.async(){
                                    let alert = UIAlertController(title: "Success", message: "Your SignUp is Successfully complete. Click OK to goto Login Page", preferredStyle: .alert)
                                    let okaction = UIAlertAction(title: "OK", style: .default, handler: self.goToLogin)
                                    alert.addAction(okaction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            else{
                                print(error?.localizedDescription)
                                // Logging Out because the user was automatically signing in after registration.
                                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                    print("The user successfully signed out of the app")
                                } catch let signOutError as NSError {
                                    print ("Error signing out: %@", signOutError)
                                }
                                DispatchQueue.main.async(){
                                    self.performSegue(withIdentifier: "signupToLogin", sender: self)
                                }
                            }
                        }
                    }
                    
                    print("The information has been successfully added")
                    self.signUpConfirmationLabel.text = "Your Information has been succesfully added"
                    
                }else{
                    print(error?.localizedDescription)
                    self.signUpConfirmationLabel.text = "\(error?.localizedDescription) Registration Failed.. Please Try Again"
                }
            })
            
            let userPreferences:[String:Any] = ["gender":sexLabel!,"hobbies":hobby]
            userDatabase.set(userPreferences, forKey: "userInfo")
        }
        else{
            print("Condition not matching")
            signUpConfirmationLabel.text = "One or More Mandatory things missing."
        }
    }
    
    func goToLogin(alert: UIAlertAction!){
        self.performSegue(withIdentifier: "signupToLogin", sender: self)
    }
    
    // when profile picture is tapped
    @IBAction func uploadProfilePicture(_ sender: UITapGestureRecognizer) {
        
        // Creating Action Sheet for ecting the image (Gallery & Photos)
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // Selecting image from the Photo Gallery
        let photoGallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default){ (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                print("  3  ")
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default){(action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    //Selecting image from Gallery
    @objc func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : Any]){
        
        let profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        setProfilePicture(imageView: self.imageSelector, imageToSet: profileImage!)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Displaying Profile Picture on the Image View
    internal func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){
        print("setProfilePicture called")
        imageView.layer.cornerRadius = 40
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    
    
    
    // Runs at first when the Image View Controller Loads.
    override func viewDidLoad() {
        // Assinging Font, Size & Color to the TextFields
        //usernameTextField.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        //usernameTextField.textColor = UIColor.black
        //usernameTextField.attributedPlaceholder = NSAttributedString(string: "UserName [Email]", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        usernameTextField = ComponentFormatter().setLabel(usernameTextField, 18, UIColor.black, UIColor.darkGray, "UserName [Email]")
        
        signUpTextLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 24.0)
        signUpTextLabel.textColor = UIColor.black
        
        //passwordTextField.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        //passwordTextField.textColor = UIColor.black
        passwordTextField = ComponentFormatter().setLabel(passwordTextField, 18, UIColor.black, UIColor.darkGray, "Password")
        
        //confirmPasswordTextField.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        //confirmPasswordTextField.textColor = UIColor.black
        confirmPasswordTextField = ComponentFormatter().setLabel(confirmPasswordTextField, 18, UIColor.black, UIColor.darkGray, "Confirm Password")
        
        sexLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        sexLabel.textColor = UIColor.black
        
        mobileTextField.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        mobileTextField.textColor = UIColor.black
        
        nameTextField = ComponentFormatter().setLabel(nameTextField, 18, UIColor.black, UIColor.darkGray, "Name")
        
        //dateOfBirthTextField.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        //dateOfBirthTextField.textColor = UIColor.black
        dateOfBirthTextField = ComponentFormatter().setLabel(dateOfBirthTextField, 18, UIColor.black, UIColor.darkGray, "DOB [DD/MM/YYYY]")
        
        mobileTextField = ComponentFormatter().setLabel(mobileTextField, 18, UIColor.black, UIColor.darkGray, "Mobile NUmber")
        
        signUpConfirmationLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        signUpConfirmationLabel.textColor = UIColor.red
        
        passwordNoMatch.font = UIFont(name: "ChalkboardSE-Bold", size: 16.0)
        passwordNoMatch.textColor = UIColor.red
        
        userNameNotValid.font = UIFont(name: "ChalkboardSE-Bold", size: 16.0)
        userNameNotValid.textColor = UIColor.red
        
        dateInvalid.font = UIFont(name: "ChalkboardSE-Bold", size: 16.0)
        dateInvalid.textColor = UIColor.red
        
        maleRadioButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 16.0)
        maleRadioButton.tintColor = UIColor.black
        
        femaleRadioButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 16.0)
        femaleRadioButton.tintColor = UIColor.black
        
        otherRadioButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 16.0)
        otherRadioButton.tintColor = UIColor.black
        
        //nameTextField.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        //nameTextField.textColor = UIColor.white
        
        hobbylabel.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        hobbylabel.textColor = UIColor.black
        
        //hobbylabel1.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        //hobbylabel1.textColor = UIColor.black
        hobbylabel1 = ComponentFormatter().setLabel(hobbylabel1, 18, UIColor.black)
        hobbylabel1.text = hobbyLabels[0]
        
        //hobbylabel2.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        //hobbylabel2.textColor = UIColor.black
        
        hobbylabel2 = ComponentFormatter().setLabel(hobbylabel2, 18, UIColor.black)
        hobbylabel2.text = hobbyLabels[1]
        
        hobbylabel3.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        hobbylabel3.textColor = UIColor.black
        hobbylabel3.text = hobbyLabels[2]
        
        hobbylabel4.font = UIFont(name: "ChalkboardSE-Bold", size: 18.0)
        hobbylabel4.textColor = UIColor.black
        hobbylabel4.text = hobbyLabels[3]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



