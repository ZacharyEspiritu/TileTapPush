//
//  OptionsMenu.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class OptionsMenu: CCNode {
    
    // MARK: Constants
    
    let defaults = NSUserDefaults.standardUserDefaults() // Implement the `NSUserDefaults` object.
    
    // We use constants to declare our NSUserDefault keys because it adds an extra degree of error prevention - if we misspell something (which also becomes less common since Swift will now be able to auto-fill our key names), we'll get a compile error, not an error during runtime.
    let hasLoadedBefore = "hasLoadedBefore"
    let misclickPenaltyKey = "misclickPenaltyKey"
    let backgroundMusicKey = "backgroundMusicKey"
    let soundEffectsKey = "soundEffectsKey"
    
    // Used to make sure that the text on the buttons is spelled correctly and can be easily updated across all buttons if so desired.
    let onText = "ON"
    let offText = "OFF"
    
    
    // MARK: Variables
    
    weak var misclickPenaltyToggleButtonText: CCLabelTTF!
    weak var backgroundMusicToggleButtonText: CCLabelTTF!
    weak var soundEffectsToggleButtonText: CCLabelTTF!
    
    
    // MARK: Memory Functions
    
    /**
    Called whenever `OptionsMenu.ccb` is loaded.
    
    Used to set the default values for the `NSUserDefaults` object, which is used to handle the options menu.
    */
    func didLoadFromCCB() {
        
        if !defaults.boolForKey(hasLoadedBefore) {
            
            defaults.setObject(true, forKey: misclickPenaltyKey)
            defaults.setObject(true, forKey: backgroundMusicKey)
            defaults.setObject(true, forKey: soundEffectsKey)
            
            defaults.setObject(true, forKey: hasLoadedBefore)
            
        }
        
        // TODO: Fix bug where buttons do not show correct state on OptionsMenu.ccb reload
        
        if !defaults.boolForKey(misclickPenaltyKey) {
            misclickPenaltyToggleButtonText.string = offText
        }
        if !defaults.boolForKey(backgroundMusicKey) {
            backgroundMusicToggleButtonText.string = offText
        }
        if !defaults.boolForKey(soundEffectsKey) {
            soundEffectsToggleButtonText.string = offText
        }
        
    }
    
    
    // MARK: Button Functions
    
    /**
    Returns the game back to the main menu.
    */
    func back() {
        var mainScene = CCBReader.load("MainScene") as! MainScene
        
        var scene = CCScene()
        scene.addChild(mainScene)
        
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
    
    // MARK: Toggle Functions
    
    /**
    Toggles the state of the misclickPenaltyKey.
    */
    func misclickPenaltyToggle() {
        
        var currentState = defaults.boolForKey(misclickPenaltyKey)
        
        if currentState {
            defaults.setBool(false, forKey: misclickPenaltyKey)
            misclickPenaltyToggleButtonText.string = offText
        }
        else {
            defaults.setBool(true, forKey: misclickPenaltyKey)
            misclickPenaltyToggleButtonText.string = onText
        }
        
    }
    
    /**
    Toggles the state of the backgroundMusicKey.
    */
    func backgroundMusicToggle() {
        
        var currentState = defaults.boolForKey(backgroundMusicKey)
        
        if currentState {
            defaults.setBool(false, forKey: backgroundMusicKey)
            backgroundMusicToggleButtonText.string = offText
        }
        else {
            defaults.setBool(true, forKey: backgroundMusicKey)
            backgroundMusicToggleButtonText.string = onText
        }
        
    }
    
    /**
    Toggles the state of the soundEffectsKey.
    */
    func soundEffectsToggle() {
        
        var currentState = defaults.boolForKey(soundEffectsKey)
        
        if currentState {
            defaults.setBool(false, forKey: soundEffectsKey)
            soundEffectsToggleButtonText.string = offText
        }
        else {
            defaults.setBool(true, forKey: soundEffectsKey)
            soundEffectsToggleButtonText.string = onText
        }
        
    }
    
    // TODO: Add color change system
    
}