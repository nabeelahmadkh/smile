//
//  editUserProfile.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 07/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import BSImagePicker
import Photos
import DLRadioButton


class editUserProfile:UIViewController{
    
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var imagesToUpload = [UIImage]()
    var selectedAssets:Int = 0
    let user = Auth.auth().currentUser?.uid
    let ref = Database.database().reference().root
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var imgView: UIImageView!
    var sexButton:String? = nil
    @IBOutlet weak var checkBox1: UIButton!
    var box1Checked:Bool = false
    @IBOutlet weak var checkBox2: UIButton!
    var box2Checked:Bool = false
    @IBOutlet weak var checkBox3: UIButton!
    var box3Checked:Bool = false
    @IBOutlet weak var checkBox4: UIButton!
    var box4Checked:Bool = false
    var checkBox = UIImage(named: "checked")
    var uncheckBox = UIImage(named: "unchecked")
    var hobbies = [String]()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var dateofbirthTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var maleRadioButton: DLRadioButton!
    @IBOutlet weak var femaleRadioButton: DLRadioButton!
    @IBOutlet weak var hobbyLabel1: UILabel!
    @IBOutlet weak var hobbyLabel2: UILabel!
    @IBOutlet weak var hobbyLabel3: UILabel!
    @IBOutlet weak var hobbyLabel4: UILabel!
    
    
    //Male Female Radio Button Selected
    @IBAction func femaleRadioButtonPressed(_ sender: Any) {
        print("Female Radio Button Selected")
        sexButton = "Female"
    }
    @IBAction func maleRadioButtonPressed(_ sender: Any) {
        print("Male Radio Button Selected")
        sexButton = "Male"
    }
    
    // Check Box Button 1 pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        if box1Checked == false{
            checkBox1.setImage(checkBox, for: UIControlState.normal)
            hobbies.append(signUpViewControler().hobbyLabels[0])
            box1Checked = true
        }
        else{
            checkBox1.setImage(uncheckBox, for: UIControlState.normal)
            if let index = hobbies.index(of: signUpViewControler().hobbyLabels[0]){
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
            hobbies.append(signUpViewControler().hobbyLabels[1])
            box2Checked = true
        }
        else{
            checkBox2.setImage(uncheckBox, for: UIControlState.normal)
            if let index = hobbies.index(of: signUpViewControler().hobbyLabels[1]) {
                hobbies.remove(at: index)
            }
            box2Checked = false
        }
        print("value of hobbies is \(hobbies)")
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        if box3Checked == false{
            checkBox3.setImage(checkBox, for: UIControlState.normal)
            hobbies.append(signUpViewControler().hobbyLabels[2])
            box3Checked = true
        }
        else{
            checkBox3.setImage(uncheckBox, for: UIControlState.normal)
            if let index = hobbies.index(of: signUpViewControler().hobbyLabels[2]) {
                hobbies.remove(at: index)
            }
            box3Checked = false
        }
        print("value of hobbies is \(hobbies)")
    }
    
    @IBAction func button4Pressed(_ sender: UIButton) {
        if box4Checked == false{
            checkBox4.setImage(checkBox, for: UIControlState.normal)
            hobbies.append(signUpViewControler().hobbyLabels[3])
            box4Checked = true
        }
        else{
            checkBox4.setImage(uncheckBox, for: UIControlState.normal)
            if let index = hobbies.index(of: signUpViewControler().hobbyLabels[3]) {
                hobbies.remove(at: index)
            }
            box4Checked = false
        }
        print("value of hobbies is \(hobbies)")
    }
    
    /*
    // Selecting Multiple Images from Gallery
    @IBAction func addImagesClicked(_ sender: Any) {
        
        // create an instance of Custom class for picking image.
        let vc = BSImagePickerViewController()
        
        //display picture gallery
        self.bs_presentImagePickerController(vc, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
            }
            
            self.convertAssetToImages()
            
        }, completion: nil)
        
    }
    
    // Converts PHAssets to Images
    func convertAssetToImages() -> Void {
        
        if SelectedAssets.count != 0{
            
            
            for i in 0..<SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    
                })
                
                let data = UIImageJPEGRepresentation(thumbnail, 0.7)
                let newImage = UIImage(data: data!)
                //imagesToUpload[i] = newImage!
                self.imagesToUpload.append(newImage! as UIImage)
                selectedAssets = SelectedAssets.count
                // call Firebase API here for uploading image to the server.
                
                self.PhotoArray.append(newImage! as UIImage)
                
            }
            
            self.imgView.animationImages = self.PhotoArray
            self.imgView.animationDuration = 3.0
            self.imgView.startAnimating()
            
        }
        
        
        print("complete photo array \(self.PhotoArray)")
    }
    
    
    func uploadImages() {
        for i in 0..<selectedAssets{
            print("in the selected array. \(i)")
            if let imageData:Data = UIImagePNGRepresentation(imagesToUpload[i])!
            {
                let profilePictureStorageRef = self.storageRef.child("userImages/\(user!)/images/img\(i)")
                
                let uploadTask = profilePictureStorageRef.putData(imageData, metadata: nil)
                {metadata, error in
                    if error == nil{
                        let downloadUrl = metadata!.downloadURL()
                        print("the download link is \(downloadUrl)")
                        self.ref.child("users").child((self.user)!).child("images").child("\(i)").setValue(downloadUrl!.absoluteString)
                        print("The file was uploaded successsfully.")
                    }
                    else{
                        print(error?.localizedDescription)
                        
                    }
                }
            }
        }
    }
    */
    
    @IBAction func logoutUser(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("The user successfully signed out of the app")
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginScreen")
            
            self.present(loginViewController, animated: true, completion: nil)
            
            
            //performSegue(withIdentifier: "backToLogin", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBAction func updateUserProfile(_ sender: Any) {
        // Upload images if any
        //uploadImages()
        
        // Uploading User Profile Data
        let sexLabel = sexButton
        let dateOfBirth = dateofbirthTextField.text
        let mobile = mobileTextField.text
        let hobby = hobbies
        let name = nameTextField.text
        let ref = Database.database().reference().root
        
        ref.child("users").child((user)!).child("dob").setValue(dateOfBirth)
        ref.child("users").child((user)!).child("sex").setValue(sexLabel)
        ref.child("users").child((user)!).child("mobile").setValue(mobile)
        ref.child("users").child((user)!).child("hobby").setValue(hobby)
        ref.child("users").child((user)!).child("name").setValue(name)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "userData") as UIViewController
        self.present(vc, animated: true, completion: nil)
        
    }


    
    override func didReceiveMemoryWarning() {
        //
    }
    
    override func viewDidLoad() {
        // Assigning Hobby Labels
        hobbyLabel1.text = signUpViewControler().hobbyLabels[0]
        hobbyLabel2.text = signUpViewControler().hobbyLabels[1]
        hobbyLabel3.text = signUpViewControler().hobbyLabels[2]
        hobbyLabel4.text = signUpViewControler().hobbyLabels[3]
        
        let user = Auth.auth().currentUser?.uid
        usernameTextField.isUserInteractionEnabled = false
        print("The User SIgned in is \(user))")
        ref.child("users").child(user!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.usernameTextField.text = value?["email"] as? String ?? ""
            self.dateofbirthTextField.text = value?["dob"] as? String ?? ""
            self.mobileTextField.text = value?["mobile"] as? String ?? ""
            self.nameTextField.text = value?["name"] as? String ?? ""
            let sex = value?["sex"] as? String ?? ""
            if(sex == "Male"){
                print("sex is MALE")
                self.maleRadioButton.isSelected = true
                self.sexButton = "Male"
            }
            else{
                print("sex is FEMALE")
                self.femaleRadioButton.isSelected = true
                self.sexButton = "Female"
            }
            let imageurl = value?["profilePicture"] as? String ?? ""
            let hobby:[String] = (value?["hobby"] as? [String]) ?? [""]
            //print("HOBBY IS \(hobby)")
            let length = hobby.count
            var hobbyOutput:String = ""
            var i = 0
            self.checkBox1.setImage(self.uncheckBox, for: UIControlState.normal)
            self.checkBox2.setImage(self.uncheckBox, for: UIControlState.normal)
            self.checkBox3.setImage(self.uncheckBox, for: UIControlState.normal)
            self.checkBox4.setImage(self.uncheckBox, for: UIControlState.normal)
            while(i < length){
                hobbyOutput.append(hobby[i])
                hobbyOutput.append(", ")
                
                if hobby[i] == signUpViewControler().hobbyLabels[0]{
                    self.checkBox1.setImage(self.checkBox, for: UIControlState.normal)
                    self.box1Checked = true
                    self.hobbies.append(signUpViewControler().hobbyLabels[0])
                }

                if hobby[i] == signUpViewControler().hobbyLabels[1]{
                    self.checkBox2.setImage(self.checkBox, for: UIControlState.normal)
                    self.box2Checked = true
                    self.hobbies.append(signUpViewControler().hobbyLabels[1])
                }
                
                if hobby[i] == signUpViewControler().hobbyLabels[2]{
                    self.checkBox2.setImage(self.checkBox, for: UIControlState.normal)
                    self.box2Checked = true
                    self.hobbies.append(signUpViewControler().hobbyLabels[2])
                }
                
                if hobby[i] == signUpViewControler().hobbyLabels[3]{
                    self.checkBox2.setImage(self.checkBox, for: UIControlState.normal)
                    self.box2Checked = true
                    self.hobbies.append(signUpViewControler().hobbyLabels[3])
                }
                
                i += 1
            }
            //print("HPBBY OUTPUT IS \(hobbyOutput)")
            
            
            
            // Printing the URL of the stored images in the console
            let images:[String] = (value?["images"] as? [String])!
            let numberofimages = images.count
            i = 0
            while(i<numberofimages){
                print("URR for images are \(images[i])")
                i += 1
            }
            
            
            // Setting the Profile Picture
            let url = URL(string: imageurl)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: data!)
                //self.profilePicture.image = image
            }
            
            print("value is \(value)")
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
