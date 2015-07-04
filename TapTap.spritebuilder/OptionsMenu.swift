//
//  OptionsMenu.swift
//  TapTap
//
//  Created by Zachary Espiritu on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum ColorButtonSide {
    case Left, Right
}
enum Color {
    case Turquoise, Gray, Orange, Red, Silver, Yellow, Purple, Blue, Green
}

class OptionsMenu: CCNode {
    
    // MARK: Constants
    
    let defaults = NSUserDefaults.standardUserDefaults() // Implement the `NSUserDefaults` object.
    
    // We use constants to declare our NSUserDefault keys because it adds an extra degree of error prevention - if we misspell something (which also becomes less common since Swift will now be able to auto-fill our key names), we'll get a compile error, not an error during runtime.
    let misclickPenaltyKey = "misclickPenaltyKey"
    let backgroundMusicKey = "backgroundMusicKey"
    let soundEffectsKey = "soundEffectsKey"
    
    let leftSideColorChoice = "leftSideColorChoice"
    let rightSideColorChoice = "rightSideColorChoice"
    
    // Used to make sure that the text on the buttons is spelled correctly and can be easily updated across all buttons if so desired.
    let onText = "ON"
    let offText = "OFF"
    
    // Used for linking `NSUserDefaults` to the `Color` enumeration. Also, serves as a reference table for convenience.
    let colorDictionary: [Color : Int] = [.Turquoise : 1,
                                          .Gray      : 2,
                                          .Orange    : 3,
                                          .Red       : 4,
                                          .Silver    : 5,
                                          .Yellow    : 6,
                                          .Purple    : 7,
                                          .Blue      : 8,
                                          .Green     : 9]
    
    
    // MARK: Variables
    
    // Used to change the text displayed on the ON/OFF toggle buttons.
    weak var misclickPenaltyToggleButtonText: CCLabelTTF!
    weak var backgroundMusicToggleButtonText: CCLabelTTF!
    weak var soundEffectsToggleButtonText: CCLabelTTF!
    
    // Used to change the visual appearance of the color selector buttons.
    weak var leftGreenButton, rightGreenButton: CCControl!
    weak var leftBlueButton, rightBlueButton: CCControl!
    weak var leftPurpleButton, rightPurpleButton: CCControl!
    weak var leftYellowButton, rightYellowButton: CCControl!
    weak var leftSilverButton, rightSilverButton: CCControl!
    weak var leftRedButton, rightRedButton: CCControl!
    weak var leftOrangeButton, rightOrangeButton: CCControl!
    weak var leftGrayButton, rightGrayButton: CCControl!
    weak var leftTurquoiseButton, rightTurquoiseButton: CCControl!
    
    
    // MARK: Memory Functions
    
    /**
    Called whenever `OptionsMenu.ccb` is loaded.
    
    Used to set the default values for the `NSUserDefaults` object, which is used to handle the options menu.
    */
    func didLoadFromCCB() {
        
        if !defaults.boolForKey(misclickPenaltyKey) {
            misclickPenaltyToggleButtonText.string = offText
        }
        if !defaults.boolForKey(backgroundMusicKey) {
            backgroundMusicToggleButtonText.string = offText
        }
        if !defaults.boolForKey(soundEffectsKey) {
            soundEffectsToggleButtonText.string = offText
        }
        
        // Restore previously set color choices.
        var leftColorChoiceInt = defaults.integerForKey(leftSideColorChoice)
        if leftColorChoiceInt == 1 { // Turquoise
            leftTurquoiseButton.selected = true
        }
        else if leftColorChoiceInt == 2 { // Gray
            leftGrayButton.selected = true
        }
        else if leftColorChoiceInt == 3 { // Orange
            leftOrangeButton.selected = true
        }
        else if leftColorChoiceInt == 4 { // Red
            leftRedButton.selected = true
        }
        else if leftColorChoiceInt == 5 { // Silver
            leftSilverButton.selected = true
        }
        else if leftColorChoiceInt == 6 { // Yellow
            leftYellowButton.selected = true
        }
        else if leftColorChoiceInt == 7 { // Purple
            leftPurpleButton.selected = true
        }
        else if leftColorChoiceInt == 8 { // Blue
            leftBlueButton.selected = true
        }
        else if leftColorChoiceInt == 9 { // Green
            leftGreenButton.selected = true
        }
        
        var rightColorChoiceInt = defaults.integerForKey(rightSideColorChoice)
        if rightColorChoiceInt == 1 { // Turquoise
            rightTurquoiseButton.selected = true
        }
        else if rightColorChoiceInt == 2 { // Gray
            rightGrayButton.selected = true
        }
        else if rightColorChoiceInt == 3 { // Orange
            rightOrangeButton.selected = true
        }
        else if rightColorChoiceInt == 4 { // Red
            rightRedButton.selected = true
        }
        else if rightColorChoiceInt == 5 { // Silver
            rightSilverButton.selected = true
        }
        else if rightColorChoiceInt == 6 { // Yellow
            rightYellowButton.selected = true
        }
        else if rightColorChoiceInt == 7 { // Purple
            rightPurpleButton.selected = true
        }
        else if rightColorChoiceInt == 8 { // Blue
            rightBlueButton.selected = true
        }
        else if rightColorChoiceInt == 9 { // Green
            rightGreenButton.selected = true
        }
        
        println("Current Left Side Color Choice: \(defaults.integerForKey(leftSideColorChoice))")
        println("Current Right Side Color Choice: \(defaults.integerForKey(rightSideColorChoice))")
        
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
    
    
    // MARK: Color Setting Master Function
    
    /**
    Used to change the color setting of a single player side. Called whenever a button that is used to switch color choices is tapped.
    
    It takes in the `ColorButtonSide` and `Color` that the tapped button is attached to and uses this information to determine which `ColorButtonSide` to update and which `Color` will be stored in the `NSUserDefaults` memory system.
    
    **Note:** Since `NSUserDefaults` can only store primitive data types and objects, the `color` parameter is converted into an `Int` using the `colorDictionary` found in the Variables section above. This `Int` is the only thing that gets stored in `NSUserDefaults`.
    
    :param: side   the `ColorButtonSide` that the tapped button is located on
    :param: color  the `Color` that the tapped button is associated with
    */
    func colorToggle(#side: ColorButtonSide, color: Color) {
        
        if side == .Left { // Left side buttons.
            
            // Set all of the button states to false to reset the visual appearance such that there are no more than one buttons highlighted at the same time.
            leftGreenButton.selected = false
            leftBlueButton.selected = false
            leftPurpleButton.selected = false
            leftYellowButton.selected = false
            leftSilverButton.selected = false
            leftRedButton.selected = false
            leftOrangeButton.selected = false
            leftGrayButton.selected = false
            leftTurquoiseButton.selected = false
            
            if color == .Green {
                leftGreenButton.selected = true
                defaults.setInteger(colorDictionary[.Green]!, forKey: leftSideColorChoice)
            }
            else if color == .Blue {
                leftBlueButton.selected = true
                defaults.setInteger(colorDictionary[.Blue]!, forKey: leftSideColorChoice)
            }
            else if color == .Purple {
                leftPurpleButton.selected = true
                defaults.setInteger(colorDictionary[.Purple]!, forKey: leftSideColorChoice)
            }
            else if color == .Yellow {
                leftYellowButton.selected = true
                defaults.setInteger(colorDictionary[.Yellow]!, forKey: leftSideColorChoice)
            }
            else if color == .Silver {
                leftSilverButton.selected = true
                defaults.setInteger(colorDictionary[.Silver]!, forKey: leftSideColorChoice)
            }
            else if color == .Red {
                leftRedButton.selected = true
                defaults.setInteger(colorDictionary[.Red]!, forKey: leftSideColorChoice)
            }
            else if color == .Orange {
                leftOrangeButton.selected = true
                defaults.setInteger(colorDictionary[.Orange]!, forKey: leftSideColorChoice)
            }
            else if color == .Gray {
                leftGrayButton.selected = true
                defaults.setInteger(colorDictionary[.Gray]!, forKey: leftSideColorChoice)
            }
            else if color == .Turquoise {
                leftTurquoiseButton.selected = true
                defaults.setInteger(colorDictionary[.Turquoise]!, forKey: leftSideColorChoice)
            }
            
            println("Left Side Color Choice: \(defaults.integerForKey(leftSideColorChoice))")
            
        }
        else if side == .Right { // Right side buttons.
            
            // Set all of the button states to false to reset the visual appearance such that there are no more than one buttons highlighted at the same time.
            rightGreenButton.selected = false
            rightBlueButton.selected = false
            rightPurpleButton.selected = false
            rightYellowButton.selected = false
            rightSilverButton.selected = false
            rightRedButton.selected = false
            rightOrangeButton.selected = false
            rightGrayButton.selected = false
            rightTurquoiseButton.selected = false
            
            if color == .Green {
                rightGreenButton.selected = true
                defaults.setInteger(colorDictionary[.Green]!, forKey: rightSideColorChoice)
            }
            else if color == .Blue {
                rightBlueButton.selected = true
                defaults.setInteger(colorDictionary[.Blue]!, forKey: rightSideColorChoice)
            }
            else if color == .Purple {
                rightPurpleButton.selected = true
                defaults.setInteger(colorDictionary[.Purple]!, forKey: rightSideColorChoice)
            }
            else if color == .Yellow {
                rightYellowButton.selected = true
                defaults.setInteger(colorDictionary[.Yellow]!, forKey: rightSideColorChoice)
            }
            else if color == .Silver {
                rightSilverButton.selected = true
                defaults.setInteger(colorDictionary[.Silver]!, forKey: rightSideColorChoice)
            }
            else if color == .Red {
                rightRedButton.selected = true
                defaults.setInteger(colorDictionary[.Red]!, forKey: rightSideColorChoice)
            }
            else if color == .Orange {
                rightOrangeButton.selected = true
                defaults.setInteger(colorDictionary[.Orange]!, forKey: rightSideColorChoice)
            }
            else if color == .Gray {
                rightGrayButton.selected = true
                defaults.setInteger(colorDictionary[.Gray]!, forKey: rightSideColorChoice)
            }
            else if color == .Turquoise {
                rightTurquoiseButton.selected = true
                defaults.setInteger(colorDictionary[.Turquoise]!, forKey: rightSideColorChoice)
            }
            
            println("Right Side Color Choice: \(defaults.integerForKey(rightSideColorChoice))")
            
        }
        
    }
    
    
    // MARK: Color Button Functions
    // See `colorToggle()` for more details.
    
    func leftGreenButtonTapped() {
        colorToggle(side: .Left, color: .Green)
    }
    
    func rightGreenButtonTapped() {
        colorToggle(side: .Right, color: .Green)
    }
    
    func leftBlueButtonTapped() {
        colorToggle(side: .Left, color: .Blue)
    }
    
    func rightBlueButtonTapped() {
        colorToggle(side: .Right, color: .Blue)
    }
    
    func leftPurpleButtonTapped() {
        colorToggle(side: .Left, color: .Purple)
    }
    
    func rightPurpleButtonTapped() {
        colorToggle(side: .Right, color: .Purple)
    }
    
    func leftYellowButtonTapped() {
        colorToggle(side: .Left, color: .Yellow)
    }
    
    func rightYellowButtonTapped() {
        colorToggle(side: .Right, color: .Yellow)
    }
    
    func leftSilverButtonTapped() {
        colorToggle(side: .Left, color: .Silver)
    }
    
    func rightSilverButtonTapped() {
        colorToggle(side: .Right, color: .Silver)
    }
    
    func leftRedButtonTapped() {
        colorToggle(side: .Left, color: .Red)
    }
    
    func rightRedButtonTapped() {
        colorToggle(side: .Right, color: .Red)
    }
    
    func leftOrangeButtonTapped() {
        colorToggle(side: .Left, color: .Orange)
    }
    
    func rightOrangeButtonTapped() {
        colorToggle(side: .Right, color: .Orange)
    }
    
    func leftGrayButtonTapped() {
        colorToggle(side: .Left, color: .Gray)
    }
    
    func rightGrayButtonTapped() {
        colorToggle(side: .Right, color: .Gray)
    }
    
    func leftTurquoiseButtonTapped() {
        colorToggle(side: .Left, color: .Turquoise)
    }
    
    func rightTurquoiseButtonTapped() {
        colorToggle(side: .Right, color: .Turquoise)
    }
    
}