//
//  CreditsScene.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class CreditsScene: CCNode {
    
    // MARK: Variables
    
    weak var creditsEnclosingNode: CCNode!
    
    
    // MARK: Functions
    
    /**
    Opens up the options menu.
    */
    func back() {
        var optionsMenuScene = CCBReader.load("OptionsMenu") as! OptionsMenu
        
        var scene = CCScene()
        scene.addChild(optionsMenuScene)
        
        var transition = CCTransition(fadeWithDuration: 1)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    override func update(delta: CCTime) {
        
        var creditsEnclosingNodeCurrentHeight: CGFloat = creditsEnclosingNode.position.y
        var creditsEnclosingNodeHeight: CGFloat = creditsEnclosingNode.contentSize.height
        
        var screenHeight = UIScreen.mainScreen().bounds.size.height
        
        if (creditsEnclosingNodeHeight + screenHeight) < creditsEnclosingNodeCurrentHeight {
            back()
        }
        
        println("TargetHeight: \(creditsEnclosingNodeHeight + screenHeight) / CurrentNodeHeight: \(creditsEnclosingNodeCurrentHeight)")
        
    }
    
}