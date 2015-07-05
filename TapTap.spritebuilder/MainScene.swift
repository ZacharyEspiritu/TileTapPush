//
//  MainScene.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    // MARK: Constants
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // See `OptionsMenu.swift` for information on these constants.
    let hasLoadedBefore = "hasLoadedBefore"
    let ingameParticlesKey = "ingameParticlesKeym"
    let backgroundMusicKey = "backgroundMusicKey"
    let soundEffectsKey = "soundEffectsKey"
    
    let leftSideColorChoice = "leftSideColorChoice"
    let rightSideColorChoice = "rightSideColorChoice"
    
    
    // MARK: Variables
    
    weak var dominantColorNode: CCNodeColor!
    weak var backgroundColorNode: CCNodeColor!
    
    
    // MARK: Functions
    
    /**
    Called whenever `MainScene.ccb` is loaded. 
    
    Its main purpose is to update the main menu screen with the color choices a user may have selected in the options menu, and to set the default settings the first time the game loads.
    */
    func didLoadFromCCB() {
        
        if !defaults.boolForKey(hasLoadedBefore) {
            
            defaults.setObject(true, forKey: ingameParticlesKey)
            defaults.setObject(true, forKey: backgroundMusicKey)
            defaults.setObject(true, forKey: soundEffectsKey)
            
            defaults.setObject(true, forKey: hasLoadedBefore)
            
            defaults.setInteger(8, forKey: leftSideColorChoice) // 8 refers to the color blue. See colorDictionary in OptionsMenu.swift.
            defaults.setInteger(4, forKey: rightSideColorChoice) // 4 refers to the color red. See colorDictionary in OptionsMenu.swift.
            
            println("Default settings loaded.")
            
        }
        
        getColorChoicesFromMemory()
    }
    
    /**
    Starts a new instance of the game.
    */
    func play() {
        var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        gameplayScene.animationManager.runAnimationsForSequenceNamed("Gameplay")
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    /**
    Opens up the options menu.
    */
    func options() {
        var optionsMenuScene = CCBReader.load("OptionsMenu") as! OptionsMenu
        
        var scene = CCScene()
        scene.addChild(optionsMenuScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    
    // MARK: Memory Functions
    
    func getColorChoicesFromMemory() {
        
        // Color presets.
        var turquoiseColor = CCColor(red: 26/255, green: 188/255, blue: 156/255)
        var grayColor = CCColor(red: 52/255, green: 73/255, blue: 94/255)
        var orangeColor = CCColor(red: 230/255, green: 126/255, blue: 34/255)
        var redColor = CCColor(red: 255/255, green: 102/255, blue: 102/255)
        var silverColor = CCColor(red: 189/255, green: 195/255, blue: 199/255)
        var yellowColor = CCColor(red: 241/255, green: 196/255, blue: 15/255)
        var purpleColor = CCColor(red: 155/255, green: 89/255, blue: 182/255)
        var blueColor = CCColor(red: 0/255, green: 0/255, blue: 255/255)
        var greenColor = CCColor(red: 39/255, green: 174/255, blue: 96/255)
        
        // Restore previously set color choices.
        var leftColorChoiceInt = defaults.integerForKey(leftSideColorChoice)
        if leftColorChoiceInt == 1 { // Turquoise
            dominantColorNode.color = turquoiseColor
        }
        else if leftColorChoiceInt == 2 { // Gray
            dominantColorNode.color = grayColor
        }
        else if leftColorChoiceInt == 3 { // Orange
            dominantColorNode.color = orangeColor
        }
        else if leftColorChoiceInt == 4 { // Red
            dominantColorNode.color = redColor
        }
        else if leftColorChoiceInt == 5 { // Silver
            dominantColorNode.color = silverColor
        }
        else if leftColorChoiceInt == 6 { // Yellow
            dominantColorNode.color = yellowColor
        }
        else if leftColorChoiceInt == 7 { // Purple
            dominantColorNode.color = purpleColor
        }
        else if leftColorChoiceInt == 8 { // Blue
            dominantColorNode.color = blueColor
        }
        else if leftColorChoiceInt == 9 { // Green
            dominantColorNode.color = greenColor
        }
        
        var rightColorChoiceInt = defaults.integerForKey(rightSideColorChoice)
        if rightColorChoiceInt == 1 { // Turquoise
            backgroundColorNode.color = turquoiseColor
        }
        else if rightColorChoiceInt == 2 { // Gray
            backgroundColorNode.color = grayColor
        }
        else if rightColorChoiceInt == 3 { // Orange
            backgroundColorNode.color = orangeColor
        }
        else if rightColorChoiceInt == 4 { // Red
            backgroundColorNode.color = redColor
        }
        else if rightColorChoiceInt == 5 { // Silver
            backgroundColorNode.color = silverColor
        }
        else if rightColorChoiceInt == 6 { // Yellow
            backgroundColorNode.color = yellowColor
        }
        else if rightColorChoiceInt == 7 { // Purple
            backgroundColorNode.color = purpleColor
        }
        else if rightColorChoiceInt == 8 { // Blue
            backgroundColorNode.color = blueColor
        }
        else if rightColorChoiceInt == 9 { // Green
            backgroundColorNode.color = greenColor
        }
        
    }
    
}