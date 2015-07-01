//
//  MainScene.swift
//  TapTap
//
//  Created by Zachary Espiritu on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    weak var dominantColor: DominantColor!
    weak var particleLine: ParticleLine!
    
    weak var world: CCNode!
    
    func didLoadFromCCB(){
        self.userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        var xTouch = touch.locationInNode(world).x
        var screenHalf = CCDirector.sharedDirector().viewSize().width / 2
        
        if xTouch < screenHalf {
            dominantColor.left()
            particleLine.position.x += 0.02
            
        }
        else {
            dominantColor.right()
            particleLine.position.x -= 0.02
        }
        
        checkIfWin()
        
    }
    
    func checkIfWin() {
        var scale = dominantColor.scaleX
        
        if scale <= 0 {
            redWins()
        }
        else if scale >= 1 {
            blueWins()
        }
    }

    func redWins() {
        println("Red wins")
        self.userInteractionEnabled = false
        
        world.animationManager.runAnimationsForSequenceNamed("RedWins")
        particleLine.stopParticleGeneration()
    }
    
    func blueWins() {
        println("Blue wins")
        self.userInteractionEnabled = false
        
        world.animationManager.runAnimationsForSequenceNamed("BlueWins")
        particleLine.stopParticleGeneration()
    }
    
    func playAgain() {
        var mainScene = CCBReader.load("MainScene") as! MainScene
        mainScene.animationManager.runAnimationsForSequenceNamed("Default Timeline")
        
        var scene = CCScene()
        scene.addChild(mainScene)
                
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func mainMenu() {
        
    }
    
}