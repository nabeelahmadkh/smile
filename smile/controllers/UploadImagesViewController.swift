//
//  uploadImagesViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 03/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit
import BSImagePicker
import Photos
import FirebaseAuth
import Firebase
import FirebaseStorage


class uploadImagesViewController: UIViewController{
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var imagesToUpload = [UIImage]()
    var selectedAssets:Int = 0
    let user = Auth.auth().currentUser?.uid
    let ref = Database.database().reference().root
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var imgView: UIImageView!
    var numberOfImages:Int = 0
    
    
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
    
    
    @IBAction func uploadImages(_ sender: Any) {
        
        if(selectedAssets > 0){
            for i in 0..<selectedAssets{
                print("in the selected array. \(i)")
                if let imageData:Data = UIImagePNGRepresentation(imagesToUpload[i])!
                {
                    let profilePictureStorageRef = self.storageRef.child("userImages/\(user!)/images/img\(i+self.numberOfImages)")
                    print("I + NUMBER OF IMAGES \(i+self.numberOfImages)")
                    
                    let uploadTask = profilePictureStorageRef.putData(imageData, metadata: nil)
                    {metadata, error in
                        if error == nil{
                            // Adding the URL of the images in the
                            let downloadUrl = metadata!.downloadURL()
                            print("the download link is \(downloadUrl)")
                            self.ref.child("users").child(self.user!).child("images").child("\(i+self.numberOfImages)").setValue(downloadUrl!.absoluteString)
                            print("The file was uploaded successsfully.")
                            
                            
                            let alert = UIAlertController(title: "Images Upload", message: "Your Images are successfully uploaded", preferredStyle: .alert)
                            let okaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okaction)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            print(error?.localizedDescription)
                            let alert = UIAlertController(title: "Images Upload", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                            let okaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okaction)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }else{
            let alert = UIAlertController(title: "No Image Selected", message: "Select the image first, then click on upload", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okaction)
            self.present(alert, animated:true, completion: nil)
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    override func viewDidLoad() {
        let user = Auth.auth().currentUser?.uid
        print("The User SIgned in is \(user))")
        
        
        ref.child("users").child(user!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let imageurl = value?["profilePicture"] as? String ?? ""
            
            // Printing the URL of the stored images in the console
            if value?["images"] != nil{
                let images:[String] = value?["images"] as? [String] ?? [""]
                self.numberOfImages = images.count
                print("IMAGES .COUNT = \(self.numberOfImages)")
            }
            
            print("value is \(value)")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}
