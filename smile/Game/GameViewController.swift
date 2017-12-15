//
//  GameViewController.swift
//  SmileGame
//
//  Created by macbook_user on 11/23/17.
//  Copyright © 2017 macbook_user. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        //making display locked in horizontal
         AppUtility.lockOrientation(.landscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // again turning back the controller to portrait
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLoad() {
        
        if(AppDelegate.gameStarted) {
            (self.view as! SKView).presentScene(nil)
            AppDelegate.gameStarted = false
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "gameToDash", sender: self)
            }
        } else {
            
            func buttonClick(sender: UIButton) {
                
                func showAlertButtonTapped(_ sender: UIButton) {
                    
                    // create the alert
                    let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = StartScene(fileNamed: "StartScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    scene.gameViewController = self
                    
                    AppDelegate.gameStarted = true
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
            }
            
        }
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

