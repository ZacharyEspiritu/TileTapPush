//
//  MainScene.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation
import GameKit

class MainScene: CCNode {
    
    // MARK: Constants
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let audio = OALSimpleAudio.sharedInstance()
    
    let mixpanel: Mixpanel = Mixpanel.sharedInstance()
    
    // See `OptionsMenu.swift` for information on these constants.
    let hasLoadedBefore = "hasLoadedBefore"
    let ingameParticlesKey = "ingameParticlesKey"
    let backgroundMusicKey = "backgroundMusicKey"
    let soundEffectsKey = "soundEffectsKey"
    
    let leftSideColorChoice = "leftSideColorChoice"
    let rightSideColorChoice = "rightSideColorChoice"
    
    let singlePlayerHighScore = "singlePlayerHighScore"
    
    
    // MARK: Variables
    
    weak var dominantColorNode: CCNodeColor!
    weak var backgroundColorNode: CCNodeColor!
    
    weak var particleLine: ParticleLine!
    
    
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
            
            defaults.setInteger(0, forKey: singlePlayerHighScore) // 4 refers to the color red. See colorDictionary in OptionsMenu.swift.
            
            println("Default settings loaded.")
            
        }
        
        if !defaults.boolForKey(ingameParticlesKey) { // Check if particles are enabled in the options.
            particleLine.stopParticleGeneration()
        }
        
        getColorChoicesFromMemory() // Load color choices from `NSUserDefaults`.
        
        setupGameCenter()
        
        iAdHandler.sharedInstance.loadInterstitialAd()
    
    }
    
    func setupGameCenter() {
        
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
        
    }
    
    /**
    Starts a new instance of the game.
    */
    func playOnePlayer() {
        var gameplayScene = CCBReader.load("SinglePlayer") as! SinglePlayer
        gameplayScene.animationManager.runAnimationsForSequenceNamed("Gameplay")
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
        mixpanel.track("One Player Mode Inititated")
        mixpanel.timeEvent("One Player Mode Session Duration")
        
    }
    
    /**
    Starts a new instance of the game.
    */
    func playTwoPlayer() {
        var gameplayScene = CCBReader.load("TwoPlayer") as! TwoPlayer
        gameplayScene.animationManager.runAnimationsForSequenceNamed("Gameplay")
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
        mixpanel.track("Two Player Mode Inititated")
        mixpanel.timeEvent("Two Player Mode Session Duration")
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
        
        mixpanel.track("Viewed Options Menu")
    }
    
    /**
    Calls the Game Center leaderboard.
    */
    func leaderboard() {
        mixpanel.track("Viewed Leaderboard")
        showLeaderboard()
    }
    
    
    // MARK: Memory Functions
    
    func getColorChoicesFromMemory() {
        
        // Color presets.
        let turquoiseColor = CCColor(red: 26/255, green: 188/255, blue: 156/255)
        let grayColor = CCColor(red: 52/255, green: 73/255, blue: 94/255)
        let orangeColor = CCColor(red: 230/255, green: 126/255, blue: 34/255)
        let redColor = CCColor(red: 255/255, green: 102/255, blue: 102/255)
        let silverColor = CCColor(red: 189/255, green: 195/255, blue: 199/255)
        let yellowColor = CCColor(red: 241/255, green: 196/255, blue: 15/255)
        let purpleColor = CCColor(red: 155/255, green: 89/255, blue: 182/255)
        let blueColor = CCColor(red: 0/255, green: 0/255, blue: 255/255)
        let greenColor = CCColor(red: 39/255, green: 174/255, blue: 96/255)
        
        // Restore previously set color choices.
        var leftColorChoiceInt = defaults.integerForKey(leftSideColorChoice)
        if leftColorChoiceInt == 1 { // Turquoise
            dominantColorNode.color = turquoiseColor
            mixpanel.track("Color Choice", properties: ["Color" : "Turquoise"])
        }
        else if leftColorChoiceInt == 2 { // Gray
            dominantColorNode.color = grayColor
            mixpanel.track("Color Choice", properties: ["Color" : "Gray"])
        }
        else if leftColorChoiceInt == 3 { // Orange
            dominantColorNode.color = orangeColor
            mixpanel.track("Color Choice", properties: ["Color" : "Orange"])
        }
        else if leftColorChoiceInt == 4 { // Red
            dominantColorNode.color = redColor
            mixpanel.track("Color Choice", properties: ["Color" : "Red"])
        }
        else if leftColorChoiceInt == 5 { // Silver
            dominantColorNode.color = silverColor
            mixpanel.track("Color Choice", properties: ["Color" : "Silver"])
        }
        else if leftColorChoiceInt == 6 { // Yellow
            dominantColorNode.color = yellowColor
            mixpanel.track("Color Choice", properties: ["Color" : "Yellow"])
        }
        else if leftColorChoiceInt == 7 { // Purple
            dominantColorNode.color = purpleColor
            mixpanel.track("Color Choice", properties: ["Color" : "Purple"])
        }
        else if leftColorChoiceInt == 8 { // Blue
            dominantColorNode.color = blueColor
            mixpanel.track("Color Choice", properties: ["Color" : "Blue"])
        }
        else if leftColorChoiceInt == 9 { // Green
            dominantColorNode.color = greenColor
            mixpanel.track("Color Choice", properties: ["Color" : "Green"])
        }
        
        var rightColorChoiceInt = defaults.integerForKey(rightSideColorChoice)
        if rightColorChoiceInt == 1 { // Turquoise
            backgroundColorNode.color = turquoiseColor
            mixpanel.track("Color Choice", properties: ["Color" : "Turquoise"])
        }
        else if rightColorChoiceInt == 2 { // Gray
            backgroundColorNode.color = grayColor
            mixpanel.track("Color Choice", properties: ["Color" : "Gray"])
        }
        else if rightColorChoiceInt == 3 { // Orange
            backgroundColorNode.color = orangeColor
            mixpanel.track("Color Choice", properties: ["Color" : "Orange"])
        }
        else if rightColorChoiceInt == 4 { // Red
            backgroundColorNode.color = redColor
            mixpanel.track("Color Choice", properties: ["Color" : "Red"])
        }
        else if rightColorChoiceInt == 5 { // Silver
            backgroundColorNode.color = silverColor
            mixpanel.track("Color Choice", properties: ["Color" : "Silver"])
        }
        else if rightColorChoiceInt == 6 { // Yellow
            backgroundColorNode.color = yellowColor
            mixpanel.track("Color Choice", properties: ["Color" : "Yellow"])
        }
        else if rightColorChoiceInt == 7 { // Purple
            backgroundColorNode.color = purpleColor
            mixpanel.track("Color Choice", properties: ["Color" : "Purple"])
        }
        else if rightColorChoiceInt == 8 { // Blue
            backgroundColorNode.color = blueColor
            mixpanel.track("Color Choice", properties: ["Color" : "Blue"])
        }
        else if rightColorChoiceInt == 9 { // Green
            backgroundColorNode.color = greenColor
            mixpanel.track("Color Choice", properties: ["Color" : "Green"])
        }
    }
    
    
    // MARK: In-App Purchase Handling
    
    func purchaseRemoveAds() {
        IAPHandler.sharedInstance.attemptPurchase("removeInterstitials")
    }
    
    func restorePurchases() {
        IAPHandler.sharedInstance.attemptRestorePurchase()
    }
}

// MARK: Game Center Handling

extension MainScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MainScene: IAPHelperDelegate {
    
    func purchaseSuccessful(productString: String) {
    
    }
    
    func purchaseFailed() {
        
    }
}