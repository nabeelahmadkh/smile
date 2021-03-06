//
//  StartScene.swift
//  SmileGame
//
//  Created by macbook_user on 11/23/17.
//  Copyright © 2017 macbook_user. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    var playButton:SKSpriteNode?
    //var menuButton:SKSpriteNode?
    
    //var gameScene:SKScene!
    var backgroundMusic: SKAudioNode!
    
    var scrollingBG:ScrollingBackground?
    weak var gameViewController : GameViewController!
    
    override func didMove(to view: SKView) {
        playButton = self.childNode(withName: "startButton") as? SKSpriteNode
        //menuButton = self.childNode(withName: "menuButton") as? SKSpriteNode
        
        scrollingBG = ScrollingBackground.scrollingNodeWithImage(imageName: "loopBG", containerWidth: self.size.width)
        
        scrollingBG?.scrollingSpeed = 3.5
        scrollingBG?.anchorPoint = .zero
        
        self.addChild(scrollingBG!)
        
        
        if let musicURL = Bundle.main.url(forResource: "background", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                let transition = SKTransition.fade(withDuration: 1)
                    if let scene = GameScene(fileNamed: "GameScene") {
                    //gameScene = GameScene(fileNamed: "GameScene")
                    print("Start Scene, Controller = \(self.gameViewController)")
                    print("Start Scene, Controller = \(self.gameViewController as! GameViewController)")
                    scene.gameViewController = self.gameViewController as! GameViewController
                    scene.scaleMode = .aspectFit
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let scrollBG = self.scrollingBG {
            scrollBG.update(currentTime: currentTime)
        }
    }
}
