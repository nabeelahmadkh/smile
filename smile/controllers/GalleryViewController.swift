//
//  galleryViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 11/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Photos

class galleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var myCollectionView: UICollectionView!
    var imageArray=[UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Treasured Moments"
        
        let layout = UICollectionViewFlowLayout()
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor=UIColor.white
        self.view.addSubview(myCollectionView)
        
        myCollectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        grabPhotos()
    }
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoItemCell
        cell.img.image=imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let vc=ImagePreviewVC()
        vc.imgArray = self.imageArray
        vc.passedContentOffset = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        //        if UIDevice.current.orientation.isPortrait {
        //            return CGSize(width: width/4 - 1, height: width/4 - 1)
        //        } else {
        //            return CGSize(width: width/6 - 1, height: width/6 - 1)
        //        }
        if DeviceInfo.Orientation.isPortrait {
            return CGSize(width: width/4 - 1, height: width/4 - 1)
        } else {
            return CGSize(width: width/6 - 1, height: width/6 - 1)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    //MARK: grab photos
    func grabPhotos(){
        imageArray = []
        
        DispatchQueue.global(qos: .background).async {
            
            
            
            // Downloading the photos from the Firebase Storage
            let ref = Database.database().reference().root
            let uid = Auth.auth().currentUser?.uid
            
            // Fetching the Image URLs from the Firebae Database
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let imageurl = value?["profilePicture"] as? String ?? ""
                
                // Printing the URL of the stored images in the console
                if value?["images"] != nil{
                    let images:[String] = value?["images"] as? [String] ?? [""]
                    
                    let length = images.count
                    var imagesURL:[String] = []
                    var i = 0
                    while(i < length){
                        imagesURL.append(images[i])
                        i += 1
                    }
                    //print("The images are \(images) and the imagesURL are \(imagesURL)")
                    let numberofimages = imagesURL.count
                    print("The number of images are \(numberofimages)")
                    i = 0
                    while(i < numberofimages){
                        print("URL for images are \(images[i])")
                        
                        let url = URL(string: images[i])
                        let data = try? Data(contentsOf: url!)
                        if let imageData = data {
                            let image = UIImage(data: data!)
                            print("IN THE IF CASE ")
                            //self.profilePictureImageView.layer.cornerRadius = 20
                            //self.profilePictureImageView.layer.borderColor = UIColor.white.cgColor
                            //self.profilePictureImageView.layer.masksToBounds = true
                            //self.profilePictureImageView.image = image
                            self.imageArray.append(image!)
                        }
                        print(" OUT OF IF")
                        i += 1
                    }
                    print("OUT OF WHILE")
                }
                print("Out of Images if ")
                
                // Downloading the Profile Picture
                //let url = URL(string: imageurl)
                //let data = try? Data(contentsOf: url!)
                /*
                if let imageData = data {
                    let image = UIImage(data: data!)
                    //self.profilePictureImageView.layer.cornerRadius = 20
                    //self.profilePictureImageView.layer.borderColor = UIColor.white.cgColor
                    //self.profilePictureImageView.layer.masksToBounds = true
                    //self.profilePictureImageView.image = image
                    self.imageArray.append(image!)
                }
                */
                //print("value is \(value)")
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    self.myCollectionView.reloadData()
                }
            }) { (error) in
                print("ERROR ---")
                print(error.localizedDescription)
            }
            
            /*
            print("This is run on the background queue")
            let imgManager=PHImageManager.default()
            
            let requestOptions=PHImageRequestOptions()
            requestOptions.isSynchronous=true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions=PHFetchOptions()
            fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            print(fetchResult.count)
            */
 
            /*
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("You got no photos.")
            }
            */
            
            print("imageArray count: \(self.imageArray.count)")
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


class PhotoItemCell: UICollectionViewCell {
    
    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        img.contentMode = .scaleAspectFill
        img.clipsToBounds=true
        self.addSubview(img)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}

