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
    let IAPhandler = IAPHandler.sharedInstance
    
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
    
    weak var removeAdsPopup: CCNode!
    
    weak var onePlayerButton: CCButton!
    weak var twoPlayerButton: CCButton!
    weak var leaderboardButton: CCButton!
    weak var optionsButton: CCButton!
    weak var removeAdsButton: CCButton!
    
    weak var purchaseRemoveAdsButton: CCButton!
    weak var restorePurchasesButton: CCButton!
    weak var backToMenuButton: CCButton!
    
    
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
            
            print("Default settings loaded.")
            
        }
        
        if !defaults.boolForKey(ingameParticlesKey) { // Check if particles are enabled in the options.
            particleLine.stopParticleGeneration()
        }
        
        if defaults.boolForKey("removeAdsIAP") {
            removeAdsButton.position = CGPoint(x: -500, y: -500)
        }
        
        removeAdsPopup.cascadeOpacityEnabled = true
        removeAdsPopup.opacity = 0
        
        getColorChoicesFromMemory() // Load color choices from `NSUserDefaults`.
        
        setupGameCenter()
        
        iAdHandler.sharedInstance.loadInterstitialAd()
        IAPhandler.delegate = self
    }
    
    func setupGameCenter() {
        
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
        
    }
    
    /**
    Starts a new instance of the game.
    */
    func playOnePlayer() {
        let gameplayScene = CCBReader.load("SinglePlayer") as! SinglePlayer
        gameplayScene.animationManager.runAnimationsForSequenceNamed("Gameplay")
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
        mixpanel.track("One Player Mode Inititated")
        mixpanel.timeEvent("One Player Mode Session Duration")
        
    }
    
    /**
    Starts a new instance of the game.
    */
    func playTwoPlayer() {
        let gameplayScene = CCBReader.load("TwoPlayer") as! TwoPlayer
        gameplayScene.animationManager.runAnimationsForSequenceNamed("Gameplay")
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
        mixpanel.track("Two Player Mode Inititated")
        mixpanel.timeEvent("Two Player Mode Session Duration")
    }
    
    /**
    Opens up the options menu.
    */
    func options() {
        let optionsMenuScene = CCBReader.load("OptionsMenu") as! OptionsMenu
        
        let scene = CCScene()
        scene.addChild(optionsMenuScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
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
        let leftColorChoiceInt = defaults.integerForKey(leftSideColorChoice)
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
        
        let rightColorChoiceInt = defaults.integerForKey(rightSideColorChoice)
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
    
    /**
    Attempts to purchase removing ads.
    */
    func purchaseRemoveAds() {
        IAPHandler.sharedInstance.attemptPurchase("removeInterstitials")
    }
    
    /**
    Attempts to restore a previous purchase of removing ads.
    */
    func restorePurchases() {
        IAPHandler.sharedInstance.attemptRestorePurchase()
    }
    
    
    // MARK: In-App Purchase Dialog Popup Cosmetic Functions
    
    /**
    Opens the popup where players can purchase the remove ads option.
    */
    func removeAds() {
        removeAdsPopup.position = CGPoint(x: 0, y: 0)
        removeAdsPopup.runAction(CCActionFadeIn(duration: 0.5))
        changeBackgroundButtonState(false)
    }
    
    /**
    Closes the popup.
    */
    func backToMenu() {
        
        removeAdsPopup.runAction(CCActionFadeOut(duration: 0.5))
        
        purchaseRemoveAdsButton.enabled = false
        restorePurchasesButton.enabled = false
        backToMenuButton.enabled = false
        
        delay(0.55) {
            self.changeBackgroundButtonState(true)
            self.removeAdsPopup.position = CGPoint(x: 1, y: 0)
            
            self.purchaseRemoveAdsButton.enabled = true
            self.restorePurchasesButton.enabled = true
            self.backToMenuButton.enabled = true
        }
    }
    
    /**
    Changes all of the main menu button states to the `newState`. Used to prevent players from hitting a main menu button and opening the popup at the same time.
    
    - parameter newState:  the desired new state for all of the background buttons to be changed to
    */
    func changeBackgroundButtonState(newState: Bool) {
        onePlayerButton.enabled = newState
        twoPlayerButton.enabled = newState
        leaderboardButton.enabled = newState
        optionsButton.enabled = newState
        removeAdsButton.enabled = newState
    }
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

// MARK: Game Center Delegate Methods
extension MainScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        let viewController = CCDirector.sharedDirector().parentViewController!
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: In-App Purchase Delegate Methods
extension MainScene: IAPHelperDelegate {
    
    func purchaseSuccessful(productString: String) {
        if productString == "removeInterstitials" {
            defaults.setBool(true, forKey: "removeAdsIAP")
            removeAdsButton.position = CGPoint(x: -500, y: -500)
            
            mixpanel.identify(mixpanel.distinctId)
            mixpanel.track("Remove Ads IAP Purchased")
            mixpanel.people.trackCharge(1)
        }
    }
    
    func purchaseFailed() {
        let error = UIAlertView()
        error.title = "Purchase Failed"
        error.message = "The purchase was unable to be completed. Please try again later."
        error.addButtonWithTitle("OK")
        error.show()
    }
}