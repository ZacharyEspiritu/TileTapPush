//
//  CreditsScene.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
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
        let optionsMenuScene = CCBReader.load("OptionsMenu") as! OptionsMenu
        
        let scene = CCScene()
        scene.addChild(optionsMenuScene)
        
        let transition = CCTransition(fadeWithDuration: 1)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    /**
    Checks to see when the animation has finished and calls `back()` when it does.
    */
    override func update(delta: CCTime) {
        
        let creditsEnclosingNodeCurrentHeight: CGFloat = creditsEnclosingNode.positionInPoints.y
        let creditsEnclosingNodeHeight: CGFloat = creditsEnclosingNode.contentSize.height
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        print("Target Height:  \((creditsEnclosingNodeHeight + screenHeight))")
        print("Current Height: \(creditsEnclosingNodeCurrentHeight)")
        
        if (creditsEnclosingNodeHeight + screenHeight) < creditsEnclosingNodeCurrentHeight {
            back()
        }
    }
    
}