//
//  MusicViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 14/11/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class MusicViewController: UIViewController  {
    //Class variables
    var ref: DatabaseReference!
    var musicList:[String] = []
    var allList:[String] = []
    var relaxList:[String] = []
    var metalList:[String] = []
    var popList:[String] = []
    
    //all of the outlets
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var playerLayer:AVPlayerLayer?
    var playButton:UIButton?
    var nextButton:UIButton?
    var prevButton:UIButton?
    var upButton:UIButton?
    var downButton:UIButton?
    var stopButton:UIButton?
    var durLabel:UILabel = UILabel();
    var curLabel:UILabel = UILabel();
    var songLabel:UILabel = UILabel();
    
    var list1:UIButton?
    var list2:UIButton?
    var list3:UIButton?
    
    var allMusicButton:UIButton!
    var relaxMusicButton:UIButton!
    var metalMusicButton:UIButton!
    var popMusicButton:UIButton!
    
    var playbackSlider:UISlider?
    //Current song from list of songs
    var listNum = 1;
    //LIST OF Audio Files
    //var listOfSongs: [String] = ["maddrums.mp3","zinbeat.wav", "fatbeat.wav", "reakbeat.mp3","laugh.wav", "red.mp3","song.mp3"]
    
    var currentSong = 0;
    var currentList = 0;
    var firstLoad:Bool = true
    
    var selectedGenre:String = "All"
    
    //let startURL = "https://dl.dropboxusercontent.com/u/2813968/beats/"
    
    override func viewDidLoad() {
        self.view = GradientSelector().setGradient(view: self.view,type: 0)
        
        /*
         ref = Database.database().reference()
         let tableRef = ref.child("music")
         
         tableRef.observeSingleEvent(of : .value, with: { snapshot in
         if snapshot.hasChildren() {
         print("Snapshot has \(snapshot.childrenCount) children")
         
         let records : [DataSnapshot] = snapshot.children.allObjects as! [DataSnapshot]
         for record in records {
         print("Record = \(record)")
         let recordVal : Dictionary<String, String> = record.value as! Dictionary<String, String>
         if(recordVal["m_category"] == "relax") {
         self.relaxList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]!)
         } else if(recordVal["m_category"] == "metal") {
         self.metalList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]!)
         } else {
         self.popList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]!)
         }
         self.musicList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]!)
         }
         }
         
         /*print("Relax Result = \(self.relaxList)")
         print("Metal Result = \(self.metalList)")
         print("Pop Result = \(self.popList)")
         print("Final Result = \(self.musicList)")*/
         
         print("URL = \(self.musicList[0].components(separatedBy: "!#@#!")[1]))")
         //self.playSound(url: URL(string : self.musicList[0].components(separatedBy: "!#@#!")[1])!)
         })
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        let tableRef = ref.child("music")
        
        musicList = []
        allList = []
        relaxList = []
        metalList = []
        popList = []
        
        tableRef.observeSingleEvent(of : .value, with: { snapshot in
            if snapshot.hasChildren() {
                print("Snapshot has \(snapshot.childrenCount) children")
                
                let records : [DataSnapshot] = snapshot.children.allObjects as! [DataSnapshot]
                for record in records {
                    print("Record = \(record)")
                    let recordVal : Dictionary<String, String> = record.value as! Dictionary<String, String>
                    if(recordVal["m_category"] == "relax") {
                        self.relaxList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]!)
                    } else if(recordVal["m_category"] == "metal") {
                        self.metalList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]!)
                    } else {
                        self.popList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]!)
                    }
                    self.allList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]!)
                }
            }
            
            
            switch (self.selectedGenre) {
            case "Relax":
                self.musicList = self.relaxList
                break;
            case "Metal":
                self.musicList = self.metalList
                break;
            case "Pop":
                self.musicList = self.popList
                break;
            default:
                self.musicList = self.allList
                break;
            }
            
            //ALL THE OUTLETS --> Buttons and Labels - placing on the screen
            print("Relax Result = \(self.relaxList)")
            print("Metal Result = \(self.metalList)")
            print("Pop Result = \(self.popList)")
            print("Final Result = \(self.musicList)")
            
            let canvas = self.view!
            print("Max X = \(canvas.bounds.maxX)")
            
            self.relaxMusicButton = UIButton()
            self.relaxMusicButton.setTitle("Relax", for: UIControlState.normal)
            self.relaxMusicButton.backgroundColor = UIColor.black
            self.relaxMusicButton.frame = CGRect(x: canvas.bounds.maxX * 0.03, y: canvas.bounds.maxY * 0.15, width: canvas.bounds.maxX * 0.28, height: canvas.bounds.maxY * 0.065)
            self.relaxMusicButton.addTarget(self, action: #selector(self.reloadMusicPlayer), for: .touchDown)
            self.view.addSubview(self.relaxMusicButton!)
            
            self.metalMusicButton = UIButton()
            self.metalMusicButton.setTitle("Metal", for: UIControlState.normal)
            self.metalMusicButton.backgroundColor = UIColor.black
            self.metalMusicButton.frame = CGRect(x: canvas.bounds.maxX * 0.36, y: canvas.bounds.maxY * 0.15, width: canvas.bounds.maxX * 0.28, height: canvas.bounds.maxY * 0.065)
            self.metalMusicButton.addTarget(self, action: #selector(self.reloadMusicPlayer), for: .touchDown)
            self.view.addSubview(self.metalMusicButton!)
            
            self.popMusicButton = UIButton()
            self.popMusicButton.setTitle("Pop", for: UIControlState.normal)
            self.popMusicButton.backgroundColor = UIColor.black
            self.popMusicButton.frame = CGRect(x: canvas.bounds.maxX * 0.69, y: canvas.bounds.maxY * 0.15, width: canvas.bounds.maxX * 0.28, height: canvas.bounds.maxY * 0.065)
            self.popMusicButton.addTarget(self, action: #selector(self.reloadMusicPlayer), for: .touchDown)
            self.view.addSubview(self.popMusicButton!)
            
            self.allMusicButton = UIButton()
            self.allMusicButton.setTitle("All", for: UIControlState.normal)
            self.allMusicButton.backgroundColor = UIColor.black
            self.allMusicButton.frame = CGRect(x: canvas.bounds.maxX * 0.3, y: canvas.bounds.maxY * 0.23, width: canvas.bounds.maxX * 0.4, height: canvas.bounds.maxY * 0.065)
            self.allMusicButton.addTarget(self, action: #selector(self.reloadMusicPlayer), for: .touchDown)
            self.view.addSubview(self.allMusicButton!)
            
            if(self.firstLoad) {
                self.allMusicButton.isEnabled = false
                self.relaxMusicButton.isEnabled = true
                self.metalMusicButton.isEnabled = true
                self.popMusicButton.isEnabled = true
                self.allMusicButton.alpha = 0.3
                self.relaxMusicButton.alpha = 1.0
                self.metalMusicButton.alpha = 1.0
                self.popMusicButton.alpha = 1.0
                self.firstLoad = false
            } else {
                if(self.selectedGenre == "All") {
                    self.allMusicButton.isEnabled = false
                    self.relaxMusicButton.isEnabled = true
                    self.metalMusicButton.isEnabled = true
                    self.popMusicButton.isEnabled = true
                    self.allMusicButton.alpha = 0.3
                    self.relaxMusicButton.alpha = 1.0
                    self.metalMusicButton.alpha = 1.0
                    self.popMusicButton.alpha = 1.0
                } else if(self.selectedGenre == "Relax") {
                    self.allMusicButton.isEnabled = true
                    self.relaxMusicButton.isEnabled = false
                    self.metalMusicButton.isEnabled = true
                    self.popMusicButton.isEnabled = true
                    self.allMusicButton.alpha = 1.0
                    self.relaxMusicButton.alpha = 0.3
                    self.metalMusicButton.alpha = 1.0
                    self.popMusicButton.alpha = 1.0
                } else if(self.selectedGenre == "Metal") {
                    self.allMusicButton.isEnabled = true
                    self.relaxMusicButton.isEnabled = true
                    self.metalMusicButton.isEnabled = false
                    self.popMusicButton.isEnabled = true
                    self.allMusicButton.alpha = 1.0
                    self.relaxMusicButton.alpha = 1.0
                    self.metalMusicButton.alpha = 0.3
                    self.popMusicButton.alpha = 1.0
                } else if(self.selectedGenre == "Pop") {
                    self.allMusicButton.isEnabled = true
                    self.relaxMusicButton.isEnabled = true
                    self.metalMusicButton.isEnabled = true
                    self.popMusicButton.isEnabled = false
                    self.allMusicButton.alpha = 1.0
                    self.relaxMusicButton.alpha = 1.0
                    self.metalMusicButton.alpha = 1.0
                    self.popMusicButton.alpha = 0.3
                }
            }
            
            //move List Up
            
            self.upButton = UIButton(type: UIButtonType.system) as UIButton
            self.upButton!.frame = CGRect(x: canvas.bounds.maxX * 0.03, y: canvas.bounds.maxY * 0.32, width: canvas.bounds.maxX * 0.15, height: canvas.bounds.maxY * 0.17)
            self.upButton!.backgroundColor = UIColor.black
            self.upButton!.setTitle("↑", for: UIControlState.normal)
            self.upButton!.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 40)
            self.upButton!.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.upButton!.addTarget(self, action: #selector(MusicViewController.upButtonTapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.upButton!)
            
            //LIST OF SONGS +++++++++++++++++++++++++++++++++++++++++++++++
            
            self.list1 = UIButton(type: UIButtonType.system) as UIButton
            self.list1!.frame = CGRect(x: canvas.bounds.maxX * 0.2, y: canvas.bounds.maxY * 0.32, width: canvas.bounds.maxX * 0.6, height: canvas.bounds.maxY * 0.05)
            self.list1!.backgroundColor = UIColor.orange
            self.list1!.tintColor = UIColor.black
            self.list1!.setTitle(self.musicList[0].components(separatedBy: "!#@#!")[0], for: UIControlState.normal)
            self.list1!.addTarget(self, action: #selector(MusicViewController.list1Tapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.list1!)
            
            self.list2 = UIButton(type: UIButtonType.system) as UIButton
            self.list2!.frame = CGRect(x: canvas.bounds.maxX * 0.2, y: canvas.bounds.maxY * 0.38, width: canvas.bounds.maxX * 0.6, height: canvas.bounds.maxY * 0.05)
            self.list2!.backgroundColor = UIColor.gray
            self.list2!.tintColor = UIColor.black
            self.list2!.setTitle(self.musicList[1].components(separatedBy: "!#@#!")[0], for: UIControlState.normal)
            self.list2!.addTarget(self, action: #selector(MusicViewController.list2Tapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.list2!)
            
            self.list3 = UIButton(type: UIButtonType.system) as UIButton
            self.list3!.frame = CGRect(x: canvas.bounds.maxX * 0.2, y: canvas.bounds.maxY * 0.44, width: canvas.bounds.maxX * 0.6, height: canvas.bounds.maxY * 0.05)
            self.list3!.backgroundColor = UIColor.gray
            self.list3!.tintColor = UIColor.black
            self.list3!.setTitle(self.musicList[2].components(separatedBy: "!#@#!")[0], for: UIControlState.normal)
            self.list3!.addTarget(self, action: #selector(MusicViewController.list3Tapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.list3!)
            
            //move List Down
            
            self.downButton = UIButton(type: UIButtonType.system) as UIButton
            self.downButton!.frame = CGRect(x: canvas.bounds.maxX * 0.82, y: canvas.bounds.maxY * 0.32, width: canvas.bounds.maxX * 0.15, height: canvas.bounds.maxY * 0.17)
            self.downButton!.backgroundColor = UIColor.black
            self.downButton!.setTitle("↓", for: UIControlState.normal)
            self.downButton!.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 40)
            self.downButton!.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.downButton!.addTarget(self, action: #selector(MusicViewController.downButtonTapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.downButton!)
            
            self.curLabel.frame = CGRect(x: canvas.bounds.maxX * 0.03, y: canvas.bounds.maxY * 0.5, width: canvas.bounds.maxX * 0.2, height: canvas.bounds.maxY * 0.065)
            // curLabel.backgroundColor = UIColor.orange
            self.curLabel.textColor = UIColor.black
            self.curLabel.textAlignment = NSTextAlignment.left
            self.curLabel.text = "00:00"
            self.view.addSubview(self.curLabel)
            
            self.durLabel.frame = CGRect(x: canvas.bounds.maxX * 0.77, y: canvas.bounds.maxY * 0.5, width: canvas.bounds.maxX * 0.2, height: canvas.bounds.maxY * 0.065)
            //  durLabel.backgroundColor = UIColor.orange
            self.durLabel.textColor = UIColor.black
            self.durLabel.textAlignment = NSTextAlignment.right
            self.durLabel.text = "00:00"
            self.view.addSubview(self.durLabel)
            
            // Add playback slider
            
            self.playbackSlider = UISlider(frame:CGRect(x: canvas.bounds.maxX * 0.03, y: canvas.bounds.maxY * 0.6, width: canvas.bounds.maxX * 0.94, height: canvas.bounds.maxY * 0.065))
            self.playbackSlider!.minimumValue = 0
            
            self.songLabel.frame = CGRect(x: canvas.bounds.maxX * 0.03, y: canvas.bounds.maxY * 0.68, width: canvas.bounds.maxX * 0.94, height: canvas.bounds.maxY * 0.065)
            // songLabel.backgroundColor = UIColor.orange
            self.songLabel.textColor = UIColor.black
            self.songLabel.textAlignment = NSTextAlignment.left
            self.songLabel.text = ""
            self.songLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            self.view.addSubview(self.songLabel)
            
            self.prevButton = UIButton(type: UIButtonType.system) as UIButton
            self.prevButton!.frame = CGRect(x: canvas.bounds.maxX * 0.25, y: canvas.bounds.maxY * 0.85, width: canvas.bounds.maxX * 0.1, height: canvas.bounds.maxY * 0.065)
            //self.prevButton!.backgroundColor = UIColor.lightGray
            self.prevButton!.setTitle("⏮️", for: UIControlState.normal)
            self.prevButton!.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 32)
            self.prevButton!.addTarget(self, action: #selector(MusicViewController.prevButtonTapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.prevButton!)
            
            self.playButton = UIButton(type: UIButtonType.system) as UIButton
            self.playButton!.frame = CGRect(x: canvas.bounds.maxX * 0.37, y: canvas.bounds.maxY * 0.85, width: canvas.bounds.maxX * 0.12, height: canvas.bounds.maxY * 0.1)
            //self.playButton!.backgroundColor = UIColor.lightGray
            self.playButton!.setTitle("▶️", for: UIControlState.normal)
            self.playButton!.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 48)
            self.playButton!.addTarget(self, action: #selector(MusicViewController.playButtonTapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.playButton!)
            
            self.stopButton = UIButton(type: UIButtonType.system) as UIButton
            self.stopButton!.frame = CGRect(x: canvas.bounds.maxX * 0.51, y: canvas.bounds.maxY * 0.85, width: canvas.bounds.maxX * 0.12, height: canvas.bounds.maxY * 0.1)
            //self.stopButton!.backgroundColor = UIColor.lightGray
            self.stopButton!.setTitle("⏹️", for: UIControlState.normal)
            self.stopButton!.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 48)
            self.stopButton!.addTarget(self, action: #selector(MusicViewController.stopButtonTapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.stopButton!)
            
            self.nextButton = UIButton(type: UIButtonType.system) as UIButton
            self.nextButton!.frame = CGRect(x: canvas.bounds.maxX * 0.65, y: canvas.bounds.maxY * 0.85, width: canvas.bounds.maxX * 0.1, height: canvas.bounds.maxY * 0.065)
            //self.nextButton!.backgroundColor = UIColor.lightGray
            self.nextButton!.setTitle("⏭️", for: UIControlState.normal)
            self.nextButton!.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 32)
            self.nextButton!.addTarget(self, action: #selector(MusicViewController.nextButtonTapped(_:)), for: .touchUpInside)
            self.view.addSubview(self.nextButton!)
            
            self.setPlayer();//setup avplayer avPlayerItem --> objects used to play audio files
        })
        
        
    }
    
    /* Function called when sliders is adjusted manually.
     */
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    
    //setup avplayer avPlayerItem --> objects used to play audio files
    func setPlayer(){
        
        let url = URL(string: self.musicList[currentSong].components(separatedBy: "!#@#!")[1])
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        
        playerLayer=AVPlayerLayer(player: player!)
        playerLayer?.frame=CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer!)
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        let mySecs = Int(seconds) % 60
        let myMins = Int(seconds / 60)
        
        //let myTimes = String(myMins) + ":" + String(mySecs);
        //durLabel.text = myTimes;
        if(mySecs < 10) {
            let myTimes = String(myMins) + ":0" + String(mySecs);
            self.durLabel.text = myTimes;//current time of audio track
        } else if(myMins < 10) {
            let myTimes = "0" + String(myMins) + ":" + String(mySecs);
            self.durLabel.text = myTimes;//current time of audio track
        } else {
            let myTimes = String(myMins) + ":" + String(mySecs);
            self.durLabel.text = myTimes;//current time of audio track
        }
        
        playbackSlider!.maximumValue = Float(seconds)
        playbackSlider!.isContinuous = false
        playbackSlider!.tintColor = UIColor.green
        
        playbackSlider?.addTarget(self, action: #selector(MusicViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(playbackSlider!)
        
        //subroutine used to keep track of current location of time in audio file
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                
                //comment out if you don't want continous play
                if(time == seconds && self.currentSong != self.musicList.count-1){
                    self.contPlay()
                }
                
                let mySecs2 = Int(time) % 60
                
                if(mySecs2 == 1){//show title of song after 1 second
                    self.songLabel.text = self.musicList[self.currentSong].components(separatedBy: "!#@#!")[0];
                }
                let myMins2 = Int(time / 60)
                
                if(mySecs2 < 10) {
                    let myTimes2 = String(myMins2) + ":0" + String(mySecs2);
                    self.curLabel.text = myTimes2;//current time of audio track
                } else if(myMins2 < 10) {
                    let myTimes2 = "0" + String(myMins2) + ":" + String(mySecs2);
                    self.curLabel.text = myTimes2;//current time of audio track
                } else {
                    let myTimes2 = String(myMins2) + ":" + String(mySecs2);
                    self.curLabel.text = myTimes2;//current time of audio track
                }
                
                self.playbackSlider!.value = Float ( time );
            }
        }
    }
    
    @objc func reloadMusicPlayer(_ sender:UIButton) {
        if(sender.title(for: UIControlState.normal)! == "All") {
            self.selectedGenre = "All"
        } else if(sender.title(for: UIControlState.normal)! == "Relax") {
            self.selectedGenre = "Relax"
        } else if(sender.title(for: UIControlState.normal)! == "Metal") {
            self.selectedGenre = "Metal"
        } else if(sender.title(for: UIControlState.normal)! == "Pop") {
            self.selectedGenre = "Pop"
        }
        
        viewWillAppear(true)
    }
    
    //play button clicked --> song plays if it was paused and vicaversa
    @objc func playButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player!.play()
            //  playButton!.setImage(UIImage(named: "29-circle-pause.png"), for: UIControlState.normal)
            playButton!.setTitle("⏸️", for: UIControlState.normal)
        } else {
            player!.pause()
            // playButton!.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
            
            playButton!.setTitle("▶️", for: UIControlState.normal)
        }
    }
    
    
    
    //next button clicked - go to next song in list and play
    @objc func nextButtonTapped(_ sender:UIButton)
    {
        if(currentSong < musicList.count - 1){
            currentSong = currentSong + 1;
            player!.pause()
            player = nil
            
            listNum = listNum + 1;//keep track of which song is being played in list
            if(listNum > 3){
                listNum = 1;
                currentList = currentList + 3;
                showSongs()
            } else {
                getListNum()
            }
            
            setPlayer();
            if player?.rate == 0
            {
                songLabel.text = "Loading...";//NOT WORKING
                player!.play()
                playButton!.setTitle("⏸️", for: UIControlState.normal)
                
            }
            
        }
    }
    
    //same as next button, but in reverse :)
    @objc func prevButtonTapped(_ sender:UIButton)
    {
        if(currentSong > 0){
            currentSong = currentSong - 1;
            player!.pause()
            player = nil
            
            listNum = listNum - 1;
            if(listNum < 1){
                listNum = 3;
                currentList = currentList - 3;
                if(currentList < 0){
                    currentList = 0;
                }
                showSongs()
            } else {
                getListNum()
            }
            
            setPlayer();
            if player?.rate == 0
            {
                player!.play()
                playButton!.setTitle("⏸️", for: UIControlState.normal)
            }
        }
    }
    
    //stops current song and sliders goes back to zero position
    @objc func stopButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            
        } else {
            player!.pause()
            playButton!.setTitle("▶️", for: UIControlState.normal)
        }
        
        
        player?.seek(to: CMTimeMake(0, 1))
        
        
    }
    
    
    //plays next song automatically when previous song finishes
    @objc func contPlay(){
        
        if(currentSong < musicList.count - 1){
            currentSong = currentSong + 1;
            listNum = listNum + 1;
            if(listNum > 3){
                listNum = 1;
            }
            getListNum()
            if(currentSong > currentList + 2){
                currentList = currentList + 3;
                showSongs()
                
            }
            player!.pause()
            player = nil
            
            setPlayer();
            if player?.rate == 0
            {
                player!.play()
                playButton!.setTitle("⏸️", for: UIControlState.normal)
            }
            
        }
    }
    
    
    //moves the list
    @objc func upButtonTapped(_ sender:UIButton)
    {
        currentList = currentList - 3;
        if(currentList < 0){
            currentList = 0;
        }
        showSongs()
    }
    
    @objc func downButtonTapped(_ sender:UIButton)
    {
        
        currentList = currentList + 3;
        
        
        
        showSongs()
        
    } // end of down method
    
    //sets background colors and currentSong to be played when down or up button is pressed
    func showSongs(){
        if(currentList < musicList.count){
            list1!.setTitle(self.musicList[currentList].components(separatedBy: "!#@#!")[0], for: UIControlState.normal)
        }else{
            list1!.setTitle(" ", for: UIControlState.normal)
        }
        
        if(currentList + 1 < musicList.count){
            list2!.setTitle(self.musicList[currentList + 1].components(separatedBy: "!#@#!")[0], for: UIControlState.normal)
        } else {
            list2!.setTitle(" ", for: UIControlState.normal)
        }
        
        
        if(currentList + 2 < musicList.count){
            list3!.setTitle(self.musicList[currentList + 2].components(separatedBy: "!#@#!")[0], for: UIControlState.normal)
        } else {
            list3!.setTitle(" ", for: UIControlState.normal)
        }
        
        getListNum()
    }//end of show songs
    
    //3 list tapped methods
    @objc func list1Tapped(_ sender:UIButton)
    {
        
        if(currentList < musicList.count){
            listNum = 1;
            currentSong = currentList;
            getListNum()
            
            playOn()
        }
        
        
    }
    
    @objc func list2Tapped(_ sender:UIButton)
    {
        
        
        
        if(currentList + 1 < musicList.count){
            currentSong = currentList + 1;
            listNum = 2;
            getListNum()
            playOn()
        }
        
    }
    
    @objc func list3Tapped(_ sender:UIButton)
    {
        if(currentList + 2 < musicList.count){
            currentSong = currentList + 2;
            listNum = 3;
            getListNum()
            playOn()
        }
        
        
    }//end of list3 tapped
    
    func playOn(){//plays song when song selected from list (slightly different then play button)
        player!.pause()
        player = nil
        
        
        
        
        setPlayer();
        if player?.rate == 0
        {
            player!.play()
            playButton!.setTitle("⏸️", for: UIControlState.normal)
        }
    }
    
    
    // determines which song is currently being played and hightlights background
    
    func getListNum(){
        list1!.backgroundColor = UIColor.gray
        list2!.backgroundColor = UIColor.gray
        list3!.backgroundColor = UIColor.gray
        
        if(currentSong > currentList + 2 || currentSong < currentList){
            listNum = 0;
            
        }
        
        if(currentSong == currentList){
            listNum = 1
        }
        
        if(currentSong == currentList + 1){
            listNum = 2
        }
        
        if(currentSong == currentList + 2){
            listNum = 3
        }
        
        if(listNum == 1){
            list1!.backgroundColor = UIColor.orange
        }
        
        if(listNum == 2){
            list2!.backgroundColor = UIColor.orange
        }
        
        if(listNum == 3){
            list3!.backgroundColor = UIColor.orange
        }
        
    }
    
    
}
