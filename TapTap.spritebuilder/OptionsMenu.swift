//
//  OptionsMenu.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class OptionsMenu: CCNode {
    
    func back() {
        var gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func credits() {
        
    }
    
}