//
//  AppDelegate.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 24/10/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    //Music Player Variables
    static var player:AVPlayer?
    static var musicList:[String] = []
    static var allList:[String] = []
    static var relaxList:[String] = []
    static var metalList:[String] = []
    static var popList:[String] = []
    static var selectedGenre:String = "All"
    static var currentIndex:Int = 0
    
    //When profile is edited, the flag will be set to true
    static var isProfileEdited:Bool = false
    
    //Color Scheme
    static var buttonColor:UIColor!
    static var labelColor:UIColor!
    static var tableCellColor:UIColor!
    static var textfieldColor:UIColor!
    static var buttonTextColor:UIColor!
    static var labelTextColor:UIColor!
    static var tableCellTextColor:UIColor!
    static var textfieldTextColor:UIColor!
    
    //Game Started
    static var gameStarted:Bool = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Access the shared, singleton audio session instance
        
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for movie playback
            try session.setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeMoviePlayback,options:[.allowBluetooth,.allowAirPlay,.mixWithOthers])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }
        
        // Configuring
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

