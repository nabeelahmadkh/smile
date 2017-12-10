//
//  VideoViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 14/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseDatabase

class VideoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference!
    
    var videoList:[String] = []
    
    let userDatabase:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        //let fb = FirebaseHelpers()
        //fb.fbSelect(tableName: "videos", selectColumnNames: ["v_url"], columnNames: [], parameters: [], isAnd: false)
        self.title = "Funny Videos"
        ref = Database.database().reference()
        let tableRef = ref.child("videos")
        
        tableRef.observeSingleEvent(of : .value, with: { snapshot in
            if snapshot.hasChildren() {
                print("Snapshot has \(snapshot.childrenCount) children")
                
                let records : [DataSnapshot] = snapshot.children.allObjects as! [DataSnapshot]
                for record in records {
                    print("Record = \(record)")
                    let recordVal : Dictionary<String, String> = record.value as! Dictionary<String, String>
                    self.videoList.append(recordVal["v_name"]! + "!#@#!" + recordVal["v_url"]!)
                }
                
                /*let enumerator = snapshot.children
                 while let record = enumerator.nextObject() as? DataSnapshot {
                 let recordValue = record.value as! Dictionary
                 //print(rest.value!["v_url"])
                 }*/
            }
            
            print("Final Result = \(self.videoList)")
            
            var gender:String = ""
            
            if let userInfo = self.userDatabase.dictionary(forKey: "userInfo") {
                print("UserInfo = \(userInfo)")
                gender = (userInfo["gender"] as! String).lowercased()
                print("Gender = \(gender)")
            }
            
            //print("Final Result inside viewDidLoad = \(FirebaseHelpers.finalResult)")
            //let canvas = self.view!
            self.scrollView = GradientSelector().setGradientScrollView(view: self.scrollView,type: gender)
            let canvas = self.scrollView!
            print("Max X = \(canvas.bounds.maxX)")
            //let vidW : CGFloat = canvas.bounds.maxX * 0.45
            let vidW : CGFloat = canvas.bounds.maxX * 0.94
            let vidH : CGFloat = vidW / 16 * 10
            let vidEvenX : CGFloat = canvas.bounds.maxX * 0.03
            let vidOddX : CGFloat = canvas.bounds.maxX - vidEvenX - vidW
            print("Video Width = \(vidW) and Height = \(vidH)")
            var vidY = canvas.bounds.maxY * 0.03
            self.scrollView.contentSize = CGSize.init(width: self.view.bounds.maxX, height: vidY + ((vidH + vidEvenX) * CGFloat((self.videoList.count +  1
                )/2)))
            var count : Int = 0
            for video in self.videoList {
                print("Name = \(video.components(separatedBy: "!#@#!")[0])")
                print("URL = \(video.components(separatedBy: "!#@#!")[1])")
                guard let videoUrl = URL(string: video.components(separatedBy: "!#@#!")[1]) else {
                    return
                }
                let imgGenerator = AVAssetImageGenerator(asset: AVURLAsset(url: videoUrl))
                do {
                    let cgImage = try imgGenerator.copyCGImage(at: CMTime.init(seconds: 1.0, preferredTimescale: CMTimeScale.init(1.0)), actualTime: nil)
                    
                    let uiImage = UIImage(cgImage: cgImage)
                    
                    let vidThumbnail = UIImageView()
                    vidThumbnail.image = uiImage
                    vidThumbnail.backgroundColor = UIColor.black
                    vidThumbnail.contentMode = UIViewContentMode.scaleAspectFit
                    vidThumbnail.isHidden = false
                    vidThumbnail.isOpaque = true
                    
                    let playButton = UIButton()
                    playButton.setTitle(video.components(separatedBy: "!#@#!")[1], for: UIControlState.selected)
                    playButton.alpha = 0.1
                    playButton.backgroundColor = UIColor.white
                    playButton.addTarget(self, action: #selector(self.playVideo), for: .touchDown)
                    
                    /*if(count % 2 == 0) {
                        vidThumbnail.frame = CGRect.init(x: vidEvenX, y: vidY, width: vidW, height: vidH)
                        playButton.frame = CGRect.init(x: vidEvenX, y: vidY, width: vidW, height: vidH)
                    } else {
                        vidThumbnail.frame = CGRect.init(x: vidOddX, y: vidY, width: vidW, height: vidH)
                        playButton.frame = CGRect.init(x: vidOddX, y: vidY, width: vidW, height: vidH)
                        vidY = vidY + vidH + vidEvenX
                    }*/
                    
                    vidThumbnail.frame = CGRect.init(x: vidEvenX, y: vidY, width: vidW, height: vidH)
                    playButton.frame = CGRect.init(x: vidEvenX, y: vidY, width: vidW, height: vidH)
                    vidY = vidY + vidH + vidEvenX
                    
                    canvas.addSubview(vidThumbnail)
                    canvas.addSubview(playButton)
                    count = count + 1
                } catch {
                    print(error)
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        print("viewDidAppear")
        var gender:String = ""
        
        if let userInfo = userDatabase.dictionary(forKey: "userInfo") {
            print("UserInfo = \(userInfo)")
            gender = (userInfo["gender"] as! String).lowercased()
            print("Gender = \(gender)")
        }
        
        //print("Final Result inside viewDidLoad = \(FirebaseHelpers.finalResult)")
        //let canvas = self.view!
        self.scrollView = GradientSelector().setGradientScrollView(view: self.scrollView,type: gender)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
        print("viewWillDisappear")
    }
    
    @objc func playVideo(sender:UIButton) {
        print("play Video being called. url = \(sender.title(for: UIControlState.selected)!)")
        guard let url = URL(string: sender.title(for: UIControlState.selected)!) else {
            return
        }
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        
        present(controller, animated: true) {
            player.play()
        }
    }
}
