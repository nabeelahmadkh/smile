//
//  MusicViewController.swift
//  VideoStream
//
//  Created by macbook_user on 12/3/17.
//  Copyright © 2017 macbook_user. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class MusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //Class variables
    var ref: DatabaseReference!
    //var musicList:[String] = []
    //var allList:[String] = []
    //var relaxList:[String] = []
    //var metalList:[String] = []
    //var popList:[String] = []
    
    //var selectedGenre:String = "All"
    
    var callFromViewDidAppear:Bool = false
    //var genreChanged:Bool = false
    var seconds:Float64 = 0
    
    //UI Components
    @IBOutlet weak var allMusicButton:UIButton!
    @IBOutlet weak var relaxMusicButton:UIButton!
    @IBOutlet weak var metalMusicButton:UIButton!
    @IBOutlet weak var popMusicButton:UIButton!
    @IBOutlet weak var playlist: UITableView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var songCurrentTime: UILabel!
    @IBOutlet weak var songEndTime: UILabel!
    @IBOutlet weak var currentSongTitle: UILabel!
    
    @IBOutlet weak var playbackSlider: UISlider!
    
    @IBOutlet var bottomView: UIView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //tableView.backgroundColor = UIColor.blue
        return AppDelegate.selectedGenre
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tableView called")
        return AppDelegate.musicList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("didSelectRow = \(indexPath.row)")
        AppDelegate.currentIndex = indexPath.row
        let url = URL(string: AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[1])
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        AppDelegate.player = AVPlayer(playerItem: playerItem)
        AppDelegate.player?.play()
        playButton!.setTitle("⏸️", for: UIControlState.normal)
        seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
        let mm = Int(seconds / 60)
        let ss = Int(seconds) % 60
        songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
        currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
        playbackSlider!.maximumValue = Float(seconds)
        playbackSlider!.isContinuous = false
        trackTime()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Table Creation")
        let cellNum:Int = indexPath.row
        let music:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "music")! as UITableViewCell
        //musicList.sort()
        //print("Final Result = \(AppDelegate.musicList)")
        if(AppDelegate.musicList.count != 0) {
            //print("Cell Num = \(cellNum)")
            music.textLabel?.text = AppDelegate.musicList[cellNum].components(separatedBy: "!#@#!")[0]
            music.textLabel?.font = music.textLabel?.font.withSize(25.0)
            music.textLabel?.textColor = AppDelegate.labelTextColor
            music.detailTextLabel?.text = AppDelegate.musicList[cellNum].components(separatedBy: "!#@#!")[2]
            music.detailTextLabel?.font = music.detailTextLabel?.font.withSize(10.0)
            music.detailTextLabel?.font = UIFont.init(name: "Avenir Next", size: 15.0)
            music.detailTextLabel?.textColor = AppDelegate.textfieldTextColor
            if(cellNum == AppDelegate.currentIndex) {
                music.imageView?.image = UIImage(named: "active")
                //music.imageView?.
                //music.accessoryView?.isHidden = false
                //music.accessoryView = UIImageView(image: UIImage(named: "active"))
            } else {
                //music.accessoryView?.isHidden = true
            }
            /*let userDatabase:UserDefaults = UserDefaults.standard
            var gender:String = ""
            
            if let userInfo = userDatabase.dictionary(forKey: "userInfo") {
                print("UserInfo = \(userInfo)")
                gender = (userInfo["gender"] as! String).lowercased()
                print("Gender = \(gender)")
            }*/
            //music.backgroundView = GradientSelector().setGradient(view: music.backgroundView!,type: gender)
            music.backgroundColor = AppDelegate.textfieldColor
        }
        return music
    }
    
    override func viewDidLoad() {
        print("View Did Load")
        ref = Database.database().reference()
        let tableRef = ref.child("music")
        
        
        
        if(!AppDelegate.musicList.isEmpty && !AppDelegate.allList.isEmpty && !AppDelegate.relaxList.isEmpty && !AppDelegate.popList.isEmpty && !AppDelegate.metalList.isEmpty) {
            
        } else {
            AppDelegate.musicList = []
            AppDelegate.allList = []
            AppDelegate.relaxList = []
            AppDelegate.metalList = []
            AppDelegate.popList = []
            tableRef.observeSingleEvent(of : .value, with: { snapshot in
                if snapshot.hasChildren() {
                    print("Snapshot has \(snapshot.childrenCount) children")
                    
                    let records : [DataSnapshot] = snapshot.children.allObjects as! [DataSnapshot]
                    for record in records {
                        //print("Record = \(record)")
                        let recordVal : Dictionary<String, String> = record.value as! Dictionary<String, String>
                        if(recordVal["m_category"] == "relax") {
                            AppDelegate.relaxList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]! + "!#@#!" + recordVal["m_details"]!)
                        } else if(recordVal["m_category"] == "metal") {
                            AppDelegate.metalList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]! + "!#@#!" + recordVal["m_details"]!)
                        } else {
                            AppDelegate.popList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]! + "!#@#!" + recordVal["m_details"]!)
                        }
                        AppDelegate.allList.append(recordVal["m_name"]! + "!#@#!" + recordVal["m_url"]! + "!#@#!" + recordVal["m_details"]!)
                    }
                }
                
                switch (AppDelegate.selectedGenre) {
                case "Relax":
                    AppDelegate.musicList = AppDelegate.relaxList
                    break;
                case "Metal":
                    AppDelegate.musicList = AppDelegate.metalList
                    break;
                case "Pop":
                    AppDelegate.musicList = AppDelegate.popList
                    break;
                default:
                    AppDelegate.musicList = AppDelegate.allList
                    break;
                }
                
                //ALL THE OUTLETS --> Buttons and Labels - placing on the screen
                //print("Relax Result = \(self.relaxList)")
                //print("Metal Result = \(self.metalList)")
                //print("Pop Result = \(self.popList)")
                //print("Final Result = \(self.musicList)")
                
                print("Before Reload")
                self.playlist.backgroundColor = AppDelegate.labelColor
                self.playlist.reloadData()
            })
        }
        
        allMusicButton.layer.borderWidth = 2.0
        allMusicButton.layer.borderColor = UIColor.black.cgColor
        relaxMusicButton.layer.borderWidth = 2.0
        relaxMusicButton.layer.borderColor = UIColor.black.cgColor
        metalMusicButton.layer.borderWidth = 2.0
        metalMusicButton.layer.borderColor = UIColor.black.cgColor
        popMusicButton.layer.borderWidth = 2.0
        popMusicButton.layer.borderColor = UIColor.black.cgColor
        
        allMusicButton.backgroundColor = AppDelegate.buttonColor
        allMusicButton.setTitleColor(AppDelegate.buttonTextColor, for: .normal)
        popMusicButton.backgroundColor = AppDelegate.buttonColor
        popMusicButton.setTitleColor(AppDelegate.buttonTextColor, for: .normal)
        metalMusicButton.backgroundColor = AppDelegate.buttonColor
        metalMusicButton.setTitleColor(AppDelegate.buttonTextColor, for: .normal)
        relaxMusicButton.backgroundColor = AppDelegate.buttonColor
        relaxMusicButton.setTitleColor(AppDelegate.buttonTextColor, for: .normal)
        
        playbackSlider.minimumTrackTintColor = AppDelegate.buttonTextColor
        playbackSlider.maximumTrackTintColor = AppDelegate.textfieldTextColor
        playbackSlider.thumbTintColor = UIColor.blue
        
        songCurrentTime.textColor = AppDelegate.buttonTextColor
        songEndTime.textColor = AppDelegate.buttonTextColor
        currentSongTitle.textColor = AppDelegate.buttonTextColor
        
        bottomView.backgroundColor = AppDelegate.buttonColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear")
        callFromViewDidAppear = true
        switch AppDelegate.selectedGenre {
        case "Relax":
            loadRelaxMusic()
            break
        case "Pop":
            loadPopMusic()
            break
        case "Metal":
            loadMetalMusic()
            break
        default:
            loadAllMusic()
            break
        }
        
        if (AppDelegate.player == nil || AppDelegate.player?.rate == 0) {
            playButton!.setTitle("▶️", for: UIControlState.normal)
        } else {
            playButton!.setTitle("⏸️", for: UIControlState.normal)
        }
        callFromViewDidAppear = false
        
        if(AppDelegate.player == nil) {
            songCurrentTime.text = "00:00"
            songEndTime.text = "--:--"
            currentSongTitle.text = ""
        } else {
            if(AppDelegate.player?.rate == 0) {
                songCurrentTime.text = "00:00"
                seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
                let mm = Int(seconds / 60)
                let ss = Int(seconds) % 60
                songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
                currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
                playbackSlider!.maximumValue = Float(seconds)
                playbackSlider!.isContinuous = false
            } else {
                seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
                let mm = Int(seconds / 60)
                let ss = Int(seconds) % 60
                songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
                currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
                playbackSlider!.maximumValue = Float(seconds)
                playbackSlider!.isContinuous = false
            }
            trackTime()
        }
    }
    
    func trackTime() {
        print("Track Time Called")
        //subroutine used to keep track of current location of time in audio file
        AppDelegate.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if(AppDelegate.player != nil && AppDelegate.player!.currentItem?.status == .readyToPlay) {
                let time : Float64 = CMTimeGetSeconds(AppDelegate.player!.currentTime());
                //Continuous Play
                //print("Time = \(time), Seconds = \(self.seconds)")
                if(Int(time) >= Int(self.seconds)-1 && self.seconds != 0) {
                    print("time >= self.seconds")
                    if(AppDelegate.currentIndex != AppDelegate.musicList.count-1){
                        AppDelegate.currentIndex = AppDelegate.currentIndex + 1
                    } else {
                        AppDelegate.currentIndex = 0
                    }
                    let url = URL(string: AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[1])
                    let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                    AppDelegate.player = AVPlayer(playerItem: playerItem)
                    AppDelegate.player?.play()
                    
                    self.songCurrentTime.text = "00:00"
                    self.seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
                    let mm = Int(self.seconds / 60)
                    let ss = Int(self.seconds) % 60
                    self.songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
                    self.currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
                    
                    self.playButton!.setTitle("⏸️", for: UIControlState.normal)
                    self.playbackSlider!.maximumValue = Float(self.seconds)
                    self.playbackSlider!.isContinuous = false
                    self.playbackSlider!.value = 0
                    self.viewDidAppear(true)
                } else {
                    let mm = Int(time / 60)
                    let ss = Int(time) % 60
                    self.songCurrentTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
                    self.playbackSlider!.value = Float(time)
                    self.playbackSlider!.maximumValue = Float(self.seconds)
                    self.playbackSlider!.isContinuous = false
                }
            }
        }
    }
    
    @IBAction func playbackSliderValueChanged(_ sender: UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        AppDelegate.player!.seek(to: targetTime)
        if(AppDelegate.player!.rate == 0) {
            AppDelegate.player?.play()
        }
    }
    
    @IBAction func loadAllMusic() {
        print("Play All Music Called")
        AppDelegate.musicList = AppDelegate.allList
        AppDelegate.selectedGenre = "All"
        allMusicButton.isEnabled = false
        relaxMusicButton.isEnabled = true
        popMusicButton.isEnabled = true
        metalMusicButton.isEnabled = true
        allMusicButton.alpha = 0.3
        relaxMusicButton.alpha = 1
        popMusicButton.alpha = 1
        metalMusicButton.alpha = 1
        print(AppDelegate.musicList)
        playlist.reloadData()
        if(callFromViewDidAppear) {
            
        } else {
            AppDelegate.player = nil
            playButton!.setTitle("▶️", for: UIControlState.normal)
            AppDelegate.currentIndex = 0
            //genreChanged = true
            seconds = 0
            songCurrentTime.text = "00:00"
            songEndTime.text = "--:--"
            currentSongTitle.text = ""
            self.playbackSlider!.value = 0
        }
    }
    
    @IBAction func loadRelaxMusic() {
        print("Play All Music Called")
        AppDelegate.selectedGenre = "Relax"
        AppDelegate.musicList = AppDelegate.relaxList
        allMusicButton.isEnabled = true
        relaxMusicButton.isEnabled = false
        popMusicButton.isEnabled = true
        metalMusicButton.isEnabled = true
        allMusicButton.alpha = 1
        relaxMusicButton.alpha = 0.3
        popMusicButton.alpha = 1
        metalMusicButton.alpha = 1
        print(AppDelegate.musicList)
        playlist.reloadData()
        if(callFromViewDidAppear) {
            
        } else {
            AppDelegate.player = nil
            playButton!.setTitle("▶️", for: UIControlState.normal)
            AppDelegate.currentIndex = 0
            //genreChanged = true
            seconds = 0
            songCurrentTime.text = "00:00"
            songEndTime.text = "--:--"
            currentSongTitle.text = ""
            self.playbackSlider!.value = 0
        }
    }
    
    @IBAction func loadPopMusic() {
        print("Play All Music Called")
        AppDelegate.selectedGenre = "Pop"
        AppDelegate.musicList = AppDelegate.popList
        allMusicButton.isEnabled = true
        relaxMusicButton.isEnabled = true
        popMusicButton.isEnabled = false
        metalMusicButton.isEnabled = true
        allMusicButton.alpha = 1
        relaxMusicButton.alpha = 1
        popMusicButton.alpha = 0.3
        metalMusicButton.alpha = 1
        print(AppDelegate.musicList)
        playlist.reloadData()
        if(callFromViewDidAppear) {
            
        } else {
            AppDelegate.player = nil
            playButton!.setTitle("▶️", for: UIControlState.normal)
            AppDelegate.currentIndex = 0
            //genreChanged = true
            seconds = 0
            songCurrentTime.text = "00:00"
            songEndTime.text = "--:--"
            currentSongTitle.text = ""
            self.playbackSlider!.value = 0
        }
    }
    
    @IBAction func loadMetalMusic() {
        print("Play All Music Called")
        AppDelegate.selectedGenre = "Metal"
        AppDelegate.musicList = AppDelegate.metalList
        allMusicButton.isEnabled = true
        relaxMusicButton.isEnabled = true
        popMusicButton.isEnabled = true
        metalMusicButton.isEnabled = false
        allMusicButton.alpha = 1
        relaxMusicButton.alpha = 1
        popMusicButton.alpha = 1
        metalMusicButton.alpha = 0.3
        print(AppDelegate.musicList)
        playlist.reloadData()
        if(callFromViewDidAppear) {
            
        } else {
            AppDelegate.player = nil
            playButton!.setTitle("▶️", for: UIControlState.normal)
            AppDelegate.currentIndex = 0
            //genreChanged = true
            seconds = 0
            songCurrentTime.text = "00:00"
            songEndTime.text = "--:--"
            currentSongTitle.text = ""
            self.playbackSlider!.value = 0
        }
    }
    
    @IBAction func playPrevious() {
        if(AppDelegate.currentIndex == 0) {
            AppDelegate.currentIndex = AppDelegate.musicList.count-1
        } else {
            AppDelegate.currentIndex = AppDelegate.currentIndex-1
        }
        let url = URL(string: AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[1])
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        AppDelegate.player = AVPlayer(playerItem: playerItem)
        AppDelegate.player?.play()
        playButton!.setTitle("⏸️", for: UIControlState.normal)
        seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
        let mm = Int(seconds / 60)
        let ss = Int(seconds) % 60
        songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
        currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
        trackTime()
    }
    
    @IBAction func playPause() {
        if(AppDelegate.player == nil) {
            let url = URL(string: AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[1])
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            AppDelegate.player = AVPlayer(playerItem: playerItem)
            AppDelegate.player?.play()
            playButton!.setTitle("⏸️", for: UIControlState.normal)
            seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
            let mm = Int(seconds / 60)
            let ss = Int(seconds) % 60
            songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
            currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
            playbackSlider!.maximumValue = Float(seconds)
            playbackSlider!.isContinuous = false
            trackTime()
        } else {
            if (AppDelegate.player?.rate == 0) {
                AppDelegate.player?.play()
                playButton!.setTitle("⏸️", for: UIControlState.normal)
                seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
                let mm = Int(seconds / 60)
                let ss = Int(seconds) % 60
                songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
                currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
                playbackSlider!.maximumValue = Float(seconds)
                playbackSlider!.isContinuous = false
                trackTime()
            } else {
                AppDelegate.player?.pause()
                playButton!.setTitle("▶️", for: UIControlState.normal)
            }
        }
    }
    
    @IBAction func stopPlay() {
        if (AppDelegate.player == nil || AppDelegate.player?.rate == 0) {
        } else {
            AppDelegate.player?.pause()
            playButton!.setTitle("▶️", for: UIControlState.normal)
        }
        AppDelegate.player?.seek(to: CMTimeMake(0, 1))
        songCurrentTime.text = "00:00"
        currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
        seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
        let mm = Int(seconds / 60)
        let ss = Int(seconds) % 60
        songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
        self.playbackSlider!.value = 0
    }
    
    @IBAction func playNext() {
        if(AppDelegate.currentIndex == AppDelegate.musicList.count-1) {
            AppDelegate.currentIndex = 0
        } else {
            AppDelegate.currentIndex = AppDelegate.currentIndex+1
        }
        let url = URL(string: AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[1])
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        AppDelegate.player = AVPlayer(playerItem: playerItem)
        AppDelegate.player?.play()
        playButton!.setTitle("⏸️", for: UIControlState.normal)
        seconds = CMTimeGetSeconds((AppDelegate.player?.currentItem?.asset.duration)!)
        let mm = Int(seconds / 60)
        let ss = Int(seconds) % 60
        songEndTime.text = ((mm < 10) ? ("0" + String(mm)) : (String(mm) + "")) + ":" + ((ss < 10) ? ("0" + String(ss)) : (String(ss) + ""))
        currentSongTitle.text = AppDelegate.musicList[AppDelegate.currentIndex].components(separatedBy: "!#@#!")[0]
        playbackSlider!.maximumValue = Float(seconds)
        playbackSlider!.isContinuous = false
        trackTime()
    }
    
}

