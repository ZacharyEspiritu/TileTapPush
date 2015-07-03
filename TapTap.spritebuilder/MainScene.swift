//
//  MainScene.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    func play() {
        var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        gameplayScene.animationManager.runAnimationsForSequenceNamed("Gameplay")
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func options() {
        var optionsMenuScene = CCBReader.load("OptionsMenu") as! OptionsMenu
        
        var scene = CCScene()
        scene.addChild(optionsMenuScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
}