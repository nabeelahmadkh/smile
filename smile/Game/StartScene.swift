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
    var helpButton:SKSpriteNode?
    
    var gameScene:SKScene!
    var backgroundMusic: SKAudioNode!
    
    var scrollingBG:ScrollingBackground?
    
    
    override func didMove(to view: SKView) {
        playButton = self.childNode(withName: "startButton") as? SKSpriteNode
        helpButton = self.childNode(withName: "help") as? SKSpriteNode
        
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
                gameScene = SKScene(fileNamed: "GameScene")
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene, transition: transition)

                
            }
            if node == helpButton {
                
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let scrollBG = self.scrollingBG {
            scrollBG.update(currentTime: currentTime)
        }
    }
}
