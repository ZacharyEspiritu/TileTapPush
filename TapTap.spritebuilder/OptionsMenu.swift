//
//  OptionsMenu.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class OptionsMenu: CCNode {
    
    // MARK: Memory Variables
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // We use constants to declare our NSUserDefault keys because it adds an extra degree of error prevention - if we misspell something (which also becomes less common since Swift will now be able to auto-fill our key names), we'll get a compile error, not an error during runtime.
    let hasLoadedBefore = "hasLoadedBefore"
    let misclickPenaltyKey = "misclickPenaltyKey"
    let backgroundMusicKey = "backgroundMusicKey"
    let soundEffectsKey = "soundEffectsKey"

    
    // MARK: Memory Functions
    
    /**
    Called whenever `OptionsMenu.ccb` is loaded.
    
    Used to set the default values for the `NSUserDefaults` object, which is used to handle the options menu.
    */
    func didLoadFromCCB() {
        
        println(defaults.boolForKey(hasLoadedBefore))
        
        if !defaults.boolForKey(hasLoadedBefore) {
            
            defaults.setObject(true, forKey: misclickPenaltyKey)
            defaults.setObject(true, forKey: backgroundMusicKey)
            defaults.setObject(true, forKey: soundEffectsKey)
            
            defaults.setObject(true, forKey: hasLoadedBefore)
            println("default settings set")
            
        }
        
        println(defaults.boolForKey(hasLoadedBefore))
        
    }
    
    
    // MARK: Button Functions
    
    /**
    Returns the game back to the main menu.
    */
    func back() {
        var gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    /**
    Rolls the credits.
    */
    func credits() {
        var creditsScene = CCBReader.load("CreditsScene") as! CreditsScene
        
        var scene = CCScene()
        scene.addChild(creditsScene)
        
        var transition = CCTransition(fadeWithDuration: 1)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    // TODO: Add toggle button functions to change settings
    
    // TODO: Add color change system
    
}