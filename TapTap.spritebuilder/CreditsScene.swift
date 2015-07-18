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
    
    let mixpanel = Mixpanel.sharedInstance()
    
    
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
    
    /**
    Checks to see when the animation has finished and calls `back()` when it does.
    */
    override func update(delta: CCTime) {
        
        var creditsEnclosingNodeCurrentHeight: CGFloat = creditsEnclosingNode.positionInPoints.y
        var creditsEnclosingNodeHeight: CGFloat = creditsEnclosingNode.contentSize.height
        
        var screenHeight = UIScreen.mainScreen().bounds.size.height
        
        println("Target Height:  \((creditsEnclosingNodeHeight + screenHeight))")
        println("Current Height: \(creditsEnclosingNodeCurrentHeight)")
        
        if (creditsEnclosingNodeHeight + screenHeight) < creditsEnclosingNodeCurrentHeight {
            back()
        }
    }
    
}