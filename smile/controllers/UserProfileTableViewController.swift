//
//  userProfileTableViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 09/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class userProfileTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var hobbiesLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var dateofbirthLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
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
    
    @IBAction func callEmergencyContact(_ sender: Any) {
        let number = "+13194008304"
        
        let formattedNumber = number.components(separatedBy:
            NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        let phoneUrl = "tel://\(formattedNumber)"
        let url:NSURL = NSURL(string: phoneUrl)!
        print("URLS IS \(url)")
        
        if #available(iOS 10, *) {
            print("ENTERED IF CASE")
            UIApplication.shared.open(url as URL, options: [:], completionHandler:
                nil)
        } else {
            print("ENTERED ELSE CASE")
            UIApplication.shared.openURL(url as URL)
        }
        
        /*
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            print("Your device doesn't support this feature.")
        }
        */
    }
    
    @IBAction func profilePictureTapped(_ sender: Any) {
        
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
        setProfilePicture(imageView: self.profilePictureImageView, imageToSet: profileImage!)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Displaying Profile Picture on the Image View
    internal func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){
        print("setProfilePicture called")
        imageView.layer.cornerRadius = 40
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
        uploadProfilePicture()
    }
    
    func uploadProfilePicture() {
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference()
        let ref = Database.database().reference().root
        if let imageData:Data = UIImagePNGRepresentation(self.profilePictureImageView.image!)!
        {
            let profilePictureStorageRef = storageRef.child("userProfiles/\((uid)!)/profilePic")
            
            let uploadTask = profilePictureStorageRef.putData(imageData, metadata: nil)
            {metadata, error in
                if error == nil{
                    let downloadUrl = metadata!.downloadURL()
                    print("the download link is \(downloadUrl)")
                    ref.child("users").child((uid)!).child("profilePicture").setValue(downloadUrl!.absoluteString)
                    print("The file was uploaded successsfully.")
                    
                }
                else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    override func viewDidLoad() {
        //let useremail = Auth.auth().currentUser?.email
        //print("The User SIgned in is \(String(describing: useremail))")
        //username.text = useremail
        //tap.cancelsTouchesInView = false
        let ref = Database.database().reference().root
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.usernameLabel.text = value?["email"] as? String ?? ""
            self.dateofbirthLabel.text = value?["dob"] as? String ?? ""
            self.mobileLabel.text = value?["mobile"] as? String ?? ""
            self.sexLabel.text = value?["sex"] as? String ?? ""
            self.nameLabel.text = value?["name"] as? String ?? ""
            let imageurl = value?["profilePicture"] as? String ?? ""
            let hobby:[String] = value?["hobby"] as? [String] ?? [""]
            //print("HOBBY IS \(hobby)")
            let length = hobby.count
            var hobbyOutput:String = ""
            var i = 0
            while(i < length){
                hobbyOutput.append(hobby[i])
                hobbyOutput.append(", ")
                i += 1
            }
            //print("HPBBY OUTPUT IS \(hobbyOutput)")
            self.hobbiesLabel.text = hobbyOutput
        
            // Printing the URL of the stored images in the console
            if value?["images"] != nil{
                let images:[String] = (value?["images"] as? [String])!
                let numberofimages = images.count
                i = 0
                while(i<numberofimages){
                    print("URR for images are \(images[i])")
                    i += 1
                }
            }
            
            
            // Setting the Profile Picture
            let url = URL(string: imageurl)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: data!)
                self.profilePictureImageView.layer.cornerRadius = 20
                self.profilePictureImageView.layer.borderColor = UIColor.white.cgColor
                self.profilePictureImageView.layer.masksToBounds = true
                self.profilePictureImageView.image = image
            }
            
            print("value is \(value)")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
