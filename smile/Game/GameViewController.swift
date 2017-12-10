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

protocol GameDelegate {
    func gameOver()
}


class GameViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: "presentView", name: NSNotification.Name(rawValue: "showController"), object: nil)
        
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
            if let scene = SKScene(fileNamed: "StartScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                //scene.GameViewController = self
                //scene.collisionDelegate = self
                //scene.delegate = self as! SKSceneDelegate
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @objc func gameOverDelegateFunc() {
        print("_______5______")
        self.performSegue(withIdentifier: "backToMenu", sender: nil)
    }
    
    func launchViewController(scene: SKScene) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard_Controller")
        present(vc, animated: true, completion: nil)
        // note that you don't need to go through a bunch of optionals to call presentViewController
        
        //var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //var vc = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard_Controller") as! UIViewController
        //self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func goToHome(){
        var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //var vc = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard_Controller") as! UIViewController
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard_Controller")
        //self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
        self.present(controller, animated: false, completion: nil)
        print("________3__________")
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

