//
//  DashboardViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 14/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference!
    
    var dashboardOptionsList:[String] = ["Meme","Video","Music","TreasuredMoments","Game","Text"]
    
    let userDatabase:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        var gender:String = ""
        
        if let userInfo = userDatabase.dictionary(forKey: "userInfo") {
            print("UserInfo = \(userInfo)")
            gender = (userInfo["gender"] as! String).lowercased()
            print("Gender = \(gender)")
            if((userInfo["hobbies"] as! [String]).contains("Food") && !dashboardOptionsList.contains("Food")) {
                dashboardOptionsList.append("Food")
            }
            if((userInfo["hobbies"] as! [String]).contains("Shopping") && !dashboardOptionsList.contains("Shop")) {
                dashboardOptionsList.append("Shop")
            }
        }
        
        if(!dashboardOptionsList.contains("Helpline")) {
            dashboardOptionsList.append("Helpline")
        }
        
        if(!dashboardOptionsList.contains("Account")) {
            dashboardOptionsList.append("Account")
        }
        
        //self.scrollView = GradientSelector().setGradientScrollView(view: self.scrollView,type: gender)
        
        //let fb = FirebaseHelpers()
        //fb.fbSelect(tableName: "videos", selectColumnNames: ["v_url"], columnNames: [], parameters: [], isAnd: false)
        
        //ref = Database.database().reference()
        /*let tableRef = ref.child("videos")
         
         tableRef.observeSingleEvent(of : .value, with: { snapshot in
         if snapshot.hasChildren() {
         print("Snapshot has \(snapshot.childrenCount) children")
         
         let records : [DataSnapshot] = snapshot.children.allObjects as! [DataSnapshot]
         for record in records {
         print("Record = \(record)")
         let recordVal : Dictionary<String, String> = record.value as! Dictionary<String, String>
         self.dashboardOptionsList.append(recordVal["v_name"]! + "!#@#!" + recordVal["v_url"]!)
         }
         
         /*let enumerator = snapshot.children
         while let record = enumerator.nextObject() as? DataSnapshot {
         let recordValue = record.value as! Dictionary
         //print(rest.value!["v_url"])
         }*/
         }
         
         print("Final Result = \(self.dashboardOptionsList)")
         
         //print("Final Result inside viewDidLoad = \(FirebaseHelpers.finalResult)")*/
        //let canvas = self.view!
        let canvas = self.scrollView!
        print("Max X = \(canvas.bounds.maxX)")
        let vidW : CGFloat = canvas.bounds.maxX * 0.45
        let vidH : CGFloat = vidW / 16 * 10
        let vidEvenX : CGFloat = canvas.bounds.maxX * 0.03
        let vidOddX : CGFloat = canvas.bounds.maxX - vidEvenX - vidW
        print("Video Width = \(vidW) and Height = \(vidH)")
        //var vidY = canvas.bounds.maxY * 0.03
        var vidY = canvas.bounds.maxX * 0.03
        self.scrollView.contentSize = CGSize.init(width: self.view.bounds.maxX, height: vidY + ((vidH + vidEvenX) * CGFloat((self.dashboardOptionsList.count +  1
            )/2)))
        var count : Int = 0
        for dashboardOption in self.dashboardOptionsList {
            //print("Name = \(dashboardOption.components(separatedBy: "!#@#!")[0])")
            //print("URL = \(dashboardOption.components(separatedBy: "!#@#!")[1])")
            /*guard let videoUrl = URL(string: dashboardOption.components(separatedBy: "!#@#!")[1]) else {
             return
             }*/
            //let imgGenerator = AVAssetImageGenerator(asset: AVURLAsset(url: videoUrl))
            //do {
            //    let cgImage = try imgGenerator.copyCGImage(at: CMTime.init(seconds: 1.0, preferredTimescale: CMTimeScale.init(1.0)), actualTime: nil)
            
            // let uiImage = UIImage(cgImage: cgImage)
            
            let dashboardThumbnail = UIImageView()
            
            let dashboardThumbnailImage : UIImage? = UIImage(named: dashboardOption)
            
            if(dashboardThumbnailImage == nil) {
                dashboardThumbnail.image = UIImage(named: "wip1")
            } else {
                dashboardThumbnail.image = dashboardThumbnailImage
            }
            
            //dashboardThumbnail.backgroundColor = UIColor.black
            dashboardThumbnail.backgroundColor = AppDelegate.labelColor
            /*if(gender == "male") {
                dashboardThumbnail.backgroundColor = UIColor(red: 130/256, green: 155/256, blue: 214/256, alpha: 1.0)
            } else if (gender == "female") {
                dashboardThumbnail.backgroundColor = UIColor(red: 230/256, green: 120/256, blue: 200/256, alpha: 1.0)
            } else if (gender == "other") {
                dashboardThumbnail.backgroundColor = UIColor(red: 183/256, green: 130/256, blue: 214/256, alpha: 1.0)
            } else {
                dashboardThumbnail.backgroundColor = UIColor(red: 116/256, green: 160/256, blue: 232/256, alpha: 1.0)
            }*/
            dashboardThumbnail.contentMode = UIViewContentMode.scaleAspectFit
            dashboardThumbnail.isHidden = false
            dashboardThumbnail.isOpaque = true
            
            let mediaLink = UIButton()
            //playButton.setTitle(dashboardOption.components(separatedBy: "!#@#!")[1], for: UIControlState.selected)
            mediaLink.setTitle(dashboardOption, for: UIControlState.selected)
            mediaLink.alpha = 0.1
            mediaLink.backgroundColor = UIColor.white
            mediaLink.addTarget(self, action: #selector(self.displayDashboard), for: .touchDown)
            
            if(count % 2 == 0) {
                dashboardThumbnail.frame = CGRect.init(x: vidEvenX, y: vidY, width: vidW, height: vidH)
                mediaLink.frame = CGRect.init(x: vidEvenX, y: vidY, width: vidW, height: vidH)
            } else {
                dashboardThumbnail.frame = CGRect.init(x: vidOddX, y: vidY, width: vidW, height: vidH)
                mediaLink.frame = CGRect.init(x: vidOddX, y: vidY, width: vidW, height: vidH)
                vidY = vidY + vidH + vidEvenX
            }
            
            canvas.addSubview(dashboardThumbnail)
            canvas.addSubview(mediaLink)
            count = count + 1
            //} catch {
            //    print(error)
            //}
        }
        
        self.scrollView = GradientSelector().setGradientScrollView(view: self.scrollView,type: gender)
        //})
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        print("viewDidAppear")
        /*var gender:String = ""
        
        if let userInfo = userDatabase.dictionary(forKey: "userInfo") {
            print("UserInfo = \(userInfo)")
            gender = (userInfo["gender"] as! String).lowercased()
            print("Gender = \(gender)")
        }
        
        self.scrollView = GradientSelector().setGradientScrollView(view: self.scrollView,type: gender)*/
        let flag = AppDelegate.isProfileEdited
        if(flag) {
            AppDelegate.isProfileEdited = false
            let subViews = self.scrollView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            self.scrollView.layer.sublayers![0].removeFromSuperlayer()
            //var count:Int = 0
            print("Dashboard List = \(dashboardOptionsList)")
            dashboardOptionsList.removeLast()
            dashboardOptionsList.removeLast()
            print("Dashboard List = \(dashboardOptionsList), dashboardOptionsList[0] = \(dashboardOptionsList[0]), end index = \(dashboardOptionsList.endIndex)")
            for count in 0...dashboardOptionsList.endIndex - 1 {
                if(dashboardOptionsList[count] == "Food") {
                    dashboardOptionsList.remove(at: count)
                    break
                }
            }
            
            print("Dashboard List = \(dashboardOptionsList)")
            
            for count in 0...dashboardOptionsList.endIndex - 1 {
                if(dashboardOptionsList[count] == "Shop") {
                    print("Count = \(count)")
                    dashboardOptionsList.remove(at: count)
                    break
                }
            }
            viewDidLoad()
        }
        print("Dashboard List = \(dashboardOptionsList)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
        print("viewWillDisappear")
    }
    
    @objc func displayDashboard(sender:UIButton) {
        if(sender.title(for: UIControlState.selected)! == "Food") {
            let grubhubUrl = URL(string: "grubhub")
            if UIApplication.shared.canOpenURL(grubhubUrl! as URL)
            {
                UIApplication.shared.open(grubhubUrl!)
                
            } else {
                //redirect to safari because the user doesn't have Instagram
                print("App not installed")
                UIApplication.shared.open(URL(string: "https://www.grubhub.com")!)
            }
        } else if (sender.title(for: UIControlState.selected)! == "Shop") {
            //UIApplication.shared.open(URL(string : "https://www.amazon.com")!, options: [:], completionHandler: nil)
            //This shit's not working
            let amazonUrl = URL(string: "amzn://")
            if UIApplication.shared.canOpenURL(amazonUrl! as URL)
            {
                UIApplication.shared.open(amazonUrl!)
                
            } else {
                //redirect to safari because the user doesn't have Instagram
                print("App not installed")
                UIApplication.shared.open(URL(string: "https://www.amazon.com")!)
            }
        } else if(sender.title(for: UIControlState.selected)! == "Video"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "dashToVideo", sender: self)
            }
        } else if(sender.title(for: UIControlState.selected)! == "Music"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "dashToMusic", sender: self)
            }
        }else if(sender.title(for: UIControlState.selected)! == "Meme"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "dashToMemes", sender: self)
            }
        }else if(sender.title(for: UIControlState.selected)! == "Helpline"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "dashToPhone", sender: self)
            }
        }
        else if(sender.title(for: UIControlState.selected)! == "Game"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                //self.performSegue(withIdentifier: "dashToGame", sender: self)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = mainStoryboard.instantiateViewController(withIdentifier: "gameViewController")
                self.present(controller, animated: false, completion: nil)
            }
        }
        else if(sender.title(for: UIControlState.selected)! == "TreasuredMoments"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "dashToGallery", sender: self)
            }
        }  else if(sender.title(for: UIControlState.selected)! == "Text"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "dashToText", sender: self)
            }
        } else if(sender.title(for: UIControlState.selected)! == "Account"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "dashToAccount", sender: self)
            }
        }else if(sender.title(for: UIControlState.selected)! == "Account"){
            print("Perform segue called")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "dashToProfile2", sender: self)
            }
        }
        else {
            /*
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: sender.title(for: UIControlState.selected)! + "_Controller") as UIViewController
            
            //let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: vc.view.bounds.maxX, height: 100))
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: vc.view.bounds.maxX, height: 35))
            let navItem = UINavigationItem(title: sender.title(for: UIControlState.selected)!);
            //let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: "selector");
            //navItem.rightBarButtonItem = doneItem;
            
            let backbutton = UIButton(type: .custom)
            backbutton.setImage(UIImage(named: "BackButton.png"), for: UIControlState.normal)
            backbutton.setTitle("Back", for: UIControlState.normal)
            backbutton.setTitleColor(backbutton.tintColor, for: UIControlState.normal)
            backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
            
            //vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
            
            navItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton);
            
            navBar.setItems([navItem], animated: false);
            vc.view.addSubview(navBar);
            vc.view.isUserInteractionEnabled = true
            
            self.present(vc, animated: true, completion: nil)
            */
        }
    }
    
    @objc func backAction() -> Void {
        print("Back Action called")
        //self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
